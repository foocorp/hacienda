# Getting your local computer set up for Hacienda development

Unlike GNU FM, Hacienda is written in Ruby on Rails.
Also unlike GNU FM, Hacienda is primarily developed on macOS, however Linux is expected to work.

## Installing Ruby

Ruby is installed via `asdf`. To install `asdf`:

`git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0`

Then edit `~/.zshrc` and add asdf to your oh-my-zsh plugins. Restart your terminal emulator. 
Now you need the ruby plugin for asdf. 

`asdf plugin add ruby`
`asdf list all ruby`
`asdf plugin-update ruby`
`asdf install ruby latest`

Next edit your `~/.tool-versions` and add: `ruby 3.3.0`

Finally: `ruby -v` will show ruby 3.3.0.

## Installing Rails

