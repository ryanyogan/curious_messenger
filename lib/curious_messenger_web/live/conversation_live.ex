defmodule CuriousMessengerWeb.ConversationLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  alias CuriousMessenger.{Auth, Chat, Repo}

  def render(assigns) do
    ~L"""
    <div>
      <b>User name:</b> <%= @user.nickname %>
    </div>
    <div>
      <b>Conversation title:</b> <%= @conversation.title %>
    </div>
    <div>
      <%= f = form_for :message, "#", [phx_submit: "send_message"] %>
        <%= label f, :content %>
        <%= text_input f, :content %>
        <%= submit "Send" %>
      </form>
    </div>
    <div>
      <b>Messages:</b>
      <%= for message <- @messages do %>
        <div>
          <b><%= message.user.nickname %></b>: <%= message.content %>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(_params, _assigns, socket) do
    {:ok, socket}
  end

  def handle_params(%{"conversation_id" => conversation_id, "user_id" => user_id}, _uri, socket) do
    CuriousMessengerWeb.Endpoint.subscribe("conversation_#{conversation_id}")

    {:noreply,
     socket
     |> assign(:user_id, user_id)
     |> assign(:conversation_id, conversation_id)
     |> assign_records()}
  end

  def handle_event(
        "send_message",
        %{"message" => %{"content" => content}},
        %{assigns: %{conversation_id: conversation_id, user_id: user_id, user: user}} = socket
      ) do
    case Chat.create_message(%{
           conversation_id: conversation_id,
           user_id: user_id,
           content: content
         }) do
      {:ok, new_message} ->
        new_message = %{new_message | user: user}

        CuriousMessengerWeb.Endpoint.broadcast!(
          "conversation_#{conversation_id}",
          "new_message",
          new_message
        )

      {:error, err} ->
        Logger.error(inspect(err))
    end

    {:noreply, socket}
  end

  def handle_info(%{event: "new_message", payload: new_message}, socket) do
    updated_messages = socket.assigns[:messages] ++ [new_message]

    {:noreply, socket |> assign(:messages, updated_messages)}
  end

  defp assign_records(%{assigns: %{user_id: user_id, conversation_id: conversation_id}} = socket) do
    user = Auth.get_user!(user_id)

    conversation =
      Chat.get_conversation!(conversation_id)
      |> Repo.preload(messages: [:user], conversation_members: [:user])

    socket
    |> assign(:user, user)
    |> assign(:conversation, conversation)
    |> assign(:messages, conversation.messages)
  end
end
