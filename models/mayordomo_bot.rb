require "telegram/bot"

class MayordomoBot
  TOKEN = ENV["MAYORDOMO_BOT_API_KEY"]

  def initialize
    @items = {}
  end

  def run
    Telegram::Bot::Client.run(TOKEN, logger: Logger.new($stdout)) do |bot|
      bot.listen do |message|
        case message.text
        when %r{/add_compra}
          @items[message.chat.id] ||= []
          @items[message.chat.id] << message.text.split(' ')[1..-1].join(' ')
          bot.api.send_message(chat_id: message.chat.id, text: "Great #{message.from.first_name}! I added #{@items[message.chat.id].last} to the list.")
        when "/show_compra"
          @items[message.chat.id] ||= []
          response = @items[message.chat.id].join("\n")
          bot.api.send_message(chat_id: message.chat.id, text: "You have #{@items[message.chat.id].size} things to buy:\n#{response}")
        when "/clear_compra"
          @items[message.chat.id] = []
          bot.api.send_message(chat_id: message.chat.id, text: "The list is empty now!")
        end
      end
    end
  end
end
