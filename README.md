# Saxophone

Project to trigger an [M&M's Rock Star Candy](http://www.amazon.com/Candy-Rific-Rockstar-0-53-Ounce/dp/B009YFI9ZU) from a Raspberry PI using [Elixir/OTP](http://elixir-lang.org), and [Nerves](http://nerves-project.org) with [homebrew-nerves](https://github.com/nerves-project/homebrew-nerves).

## Setup

Currently configured for the Sax button to be on GPIO pin 4; this is soldered to the ground on the M&M's trigger button. There is also an LED you can switch on and off on port 17. Configuration is in [config.exs](blob/master/config/config.exs), obviously.

See [Homebrew nerves](https://github.com/nerves-project/homebrew-nerves) to get on the PI.

## Triggering

On the PI it listens on 80; you'll need to connect to your network using the Ethernet. There's a horrid webpage with buttons for triggering the Sax player, and turning the LED on and off.

## Acknowledgement

Inspired by Keyvan Fatehi's [garage door controller post](http://keyvanfatehi.com/2015/12/17/wifi-garage-door/)

## Todo

* Better README
* Blog post (which will be on the [Cultivate Blog](http://www.cultivatehq.com/posts/))
* Slack integration
