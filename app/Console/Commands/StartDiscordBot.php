<?php

namespace App\Console\Commands;

use Discord\Discord;
use Discord\Parts\Channel\Message;
use Discord\WebSockets\Event;
use Discord\WebSockets\Intents;
use Illuminate\Console\Command;

class StartDiscordBot extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:start-discord-bot';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'This command start the discord listener server';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $discord = new Discord([
            'token' => env('DISCORD_TOKEN'),
            'intents' => Intents::getDefaultIntents()
            ]
        );

        $discord->on('ready', function(Discord $discord) {
            echo 'Bot is ready !', PHP_EOL;

            // Listen for messages.
            $discord->on(Event::MESSAGE_CREATE, function (Message $message) {
                echo "{$message->author->username}: {$message->content}", PHP_EOL;
            });
        });
    }
}
