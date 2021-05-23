defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  alias Rumbl.{Accounts, Multimedia}
  alias RumblWeb.AnnotationView

  def join("videos:" <> video_id, params, socket) do
    send(self(), :after_join)

    lastSeenInserted_at = params["last_seen_inserted_at"]
    video = Multimedia.get_video!(video_id)

    annotations =
      video
      |> Multimedia.list_annotations(lastSeenInserted_at)
      |> Phoenix.View.render_many(AnnotationView, "annotation.json")

    {:ok, %{annotations: annotations}, assign(socket, :video_id, video_id)}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", RumblWeb.Presence.list(socket))

    {:ok, _} =
      RumblWeb.Presence.track(
        socket,
        socket.assigns.user_id,
        %{device: "browser"}
      )

    {:noreply, socket}
  end

  def handle_in(event, params, socket) do
    user = Accounts.get_user!(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    case Multimedia.annotate_video(user, socket.assigns.video_id, params) do
      {:ok, annotation} ->
        broadcast_annotation(socket, annotation)
        Task.start(fn -> compute_additional_info(annotation, socket) end)

        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  defp broadcast_annotation(socket, annotation) do
    broadcast!(
      socket,
      "new_annotation",
      RumblWeb.AnnotationView.render("annotation.json", %{annotation: annotation})
    )
  end

  defp compute_additional_info(annotation, socket) do
    for result <-
          InfoSys.compute(annotation.body, limit: 1, timeout: 10_000) do
      backend_user = Accounts.get_user_by(username: result.backend.name())
      attrs = %{body: result.text, at: annotation.at}

      case Multimedia.annotate_video(
             backend_user,
             annotation.video_id,
             attrs
           ) do
        {:ok, info_ann} ->
          broadcast_annotation(socket, info_ann)

        {:error, _changeset} ->
          :ignore
      end
    end
  end
end
