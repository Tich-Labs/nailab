begin
  puts "Inserting messages for conversation 1..."
  conv = Conversation.find_by(id: 1)
  raise 'Conversation 1 not found' unless conv

  # sender ids: conversation.user_id (founder), mentor.user_id
  founder_id = conv.user_id
  mentor_user_id = conv.mentor.user_id

  Message.create!(conversation: conv, sender_id: founder_id, content: "Hi, I'd like to connect about mentorship opportunities.")
  Message.create!(conversation: conv, sender_id: mentor_user_id, content: "Hi, happy to help — tell me more about your startup and goals.")
  Message.create!(conversation: conv, sender_id: founder_id, content: "Thanks — I'll share details soon and propose times next week.")

  puts "Inserted messages successfully."
rescue => e
  puts "Insert error: #{e.class} - #{e.message}"
  puts e.backtrace.join("\n")
  exit 1
end
