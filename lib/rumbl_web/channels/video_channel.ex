defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  alias Rumbl.{Accounts, Multimedia}
  alias RumblWeb.AnnotationView

  def join("videos:" <> video_id, params, socket) do
    lastSeenInserted_at = params["last_seen_inserted_at"]
    video = Multimedia.get_video!(video_id)
    annotations =
      video
      |> Multimedia.list_annotations(lastSeenInserted_at)
      |> Phoenix.View.render_many(AnnotationView, "annotation.json")

    {:ok, %{annotations: annotations}, assign(socket, :video_id, video_id)}
  end

  @spec handle_in(
          <<_::112>>,
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any},
          atom
          | %{
              :assigns => atom | %{:user_id => any, :video_id => any, optional(any) => any},
              optional(any) => any
            }
        ) ::
          {:reply, :ok | {:error, %{errors: any}},
           atom
           | %{:assigns => atom | %{:video_id => any, optional(any) => any}, optional(any) => any}}
  def handle_in(event, params, socket) do
    user = Accounts.get_user!(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    case Multimedia.annotate_video(user, socket.assigns.video_id, params) do
      {:ok, annotation} ->
        broadcast!(socket, "new_annotation", %{
          id: annotation.id,
          user: RumblWeb.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        })
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
