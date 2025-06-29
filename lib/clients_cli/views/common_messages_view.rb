class CommonMessagesView
  def self.show_unknown_command(input)
    puts <<~SCREEN
      ❌ Unknown command: '#{input}'
      💡 Type 'h' or 'help' for available commands
    SCREEN
  end

  def self.show_goodbye
    puts "👋 Goodbye!"
  end

  def self.show_returning_to_menu
    puts "👋 Returning to main menu"
  end

  def self.clear_screen
    system('clear') || system('cls')
  end
end 
