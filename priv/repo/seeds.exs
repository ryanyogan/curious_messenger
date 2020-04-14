alias CuriousMessenger.Auth.User
alias CuriousMessenger.Chat.{Conversation, ConversationMember}

alias CuriousMessenger.{Auth, Chat}

{:ok, %User{id: u1_id}} = Auth.create_user(%{nickname: "User One"})
{:ok, %User{id: u2_id}} = Auth.create_user(%{nickname: "User Two"})

{:ok, %Conversation{id: conv_id}} = Chat.create_conversation(%{title: "Modern Talking"})

{:ok, %ConversationMember{}} =
  Chat.create_conversation_member(%{conversation_id: conv_id, user_id: u1_id, owner: true})

{:ok, %ConversationMember{}} =
  Chat.create_conversation_member(%{conversation_id: conv_id, user_id: u2_id, owner: false})
