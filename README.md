<a name="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

OH, SHIT... HERE WE GO AGAIN!!!!

Yes, i know, you are tired of just see neovim configs here... BUT WHAT I CAN DO?!?!?! Create new neovim's configs is very addictive =P

And now, with neovim 0.10, i have a lot to change in my previous config, sooooo... why not start all over again??

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#folder-structure">Folder Structure</a>
    </li> 
    <li>
      <a href="#plugins-list">Plugins List</a>
      <ul>
        <li>
            <a href="#which-key">Which Key</a>
        </li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>


## Folder Structure

Soooo... let's start with our folder structure, i decided to change the folder structure a little bit of my previous version. For this version i decided to try a modularizable version with each module taking care of what's it responsability.

Here's a simple, but modularized, example of how this folder's structure looks like:

```
~/.config/nvim/
│
├── init.lua                    # Main configuration file that sources other files
│
├── lua
│    ├── after/                 # Settings that override default settings
│    │   ├── ftplugin/          # Filetype-specific overrides
│    │   │   ├── typescript.lua # Overrides for Typescript files
│    │   │   └── javascript.lua # Overrides for JavaScript files
│    │   ├── plugin/            # Plugin-specific overrides
│    │   │   ├── nerdtree.lua   # Overrides for NERDTree plugin
│    │   │   └── fugitive.lua   # Overrides for Fugitive plugin
│    │   └── init.lua           # Default export file
│    │ 
│    ├── autoload/
│    │   ├── init.lua           # Default export file
│    │   └── lazy.lua           # Lazy plugin manager autoload settings
│    │ 
│    ├── colors/                # Contains color scheme files    
│    │   ├── init.lua           # Default export file
│    │   └── catppuccin.lua     # The expecific theme settings
│    │     
│    ├── filetypes/             # Filetype-specific settings
│    │   ├── init.lua           # Default export file
│    │   ├── python.lua         # Settings specific to Python files
│    │   └── javascript.lua     # Settings specific to JavaScript files
│    │  
│    ├── plugins/               # Holds plugin configurations
│    │   ├── init.lua           # Default export file
│    │   ├── whichkey.lua       # Shows your keymaps in a navegatable panel
│    │   └── fugitive.lua       # Configuration for Fugitive plugin   
│    │ 
│    ├── settings/              # General settings
│    │   ├── init.lua           # Default export file
│    │   ├── options.lua        # General options like tab settings, line numbers, etc.
│    │   └── mappings.lua       # Key mappings for common actions
│    │ 
│    │
│    ├── snippets/              # Contains snippet files for UltiSnips or other snippet plugins
│    │   ├── init.lua           # Default export file
│    │   └── python.snippets    # Snippets for Python files
│    │
│    └── syntax/                # Syntax highlighting customizations
│        ├── init.lua           # Default export file
│        └── mylang.lua         # Custom syntax highlighting for specific languages
│ 
├── .gitignore                  # Settings for git not upload some files
│ 
└── README.md                   # Documentation for the configuration
```

## Plugins List

I'm still working on my plugins cuz... what's neovim without the sweet tasty of a ton of plugins????

As Count Dracula once said:
> **"What's is a 'NEOVIM'?! A miserable little pile of 'PLUGINS'..."**

So, let's create a little list of all my installed plugins with, or without, some explanations.

### Which Key

[Folke's Which Key](https://github.com/folke/which-key.nvim)

From a Vim/Neovim monster, AKA Folke, Which Key is a amazing plugin that shows a panel with your defined key bindings.

For people as me, that almost forgot everything, this plugin is gold cuz, even if you forgot which key you defined, it can show for you how can you do something.

In the plugin configuration file, located on ```~/.config/nvim/lua/plugins/whichkey.lua```, you can define how the plugin popup will show, new key bindings for every action you want and the plugin behavior.

For example, let's say that you want to save your file without typing ```:w<CR>``` in the command pallete, you can configure which-key to do that by pressing ```<leader>s```, then you can see this on which key popup, even if you forget this again, just by pressing the ```<leader>``` key

### LazyGit

[Oh my God, how I love this plugin](https://github.com/kdheepak/lazygit.nvim)

For the most part of the world, using Git commands it's just type commands on CLI, others uses GUI as Github Desktop, but, as a Neovim user, why not to use a CLI/GUI interface inside Neovim?!?!?!?!

And than was born LazyGit for Neovim, this is an amazing plugin that utilize the terminal plugin LazyGit inside Neovim interface.

It's one of the best way of deal with GIT inside Neovim, IMO.

To use it you'll have to install the [LazyGit plugin](https://github.com/jesseduffield/lazygit) for your terminal and [Plenary](https://github.com/nvim-lua/plenary.nvim) that is a plugin to deal with some Neovim Lua Code.

## License

Distributed under the MIT License.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contact

Bruno Garcia Moura - itsme@bgarciamoura.com


<p align="right">(<a href="#readme-top">back to top</a>)</p>


[contributors-shield]: https://img.shields.io/github/contributors/bgarciamoura/neovim-0.10-config.svg?style=for-the-badge
[contributors-url]: https://github.com/bgarciamoura/neovim-0.10-config/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/bgarciamoura/neovim-0.10-config.svg?style=for-the-badge
[forks-url]: https://github.com/bgarciamoura/neovim-0.10-config/network/members
[stars-shield]: https://img.shields.io/github/stars/bgarciamoura/neovim-0.10-config.svg?style=for-the-badge
[stars-url]: https://github.com/bgarciamoura/neovim-0.10-config/stargazers
[issues-shield]: https://img.shields.io/github/issues/bgarciamoura/neovim-0.10-config.svg?style=for-the-badge
[issues-url]: https://github.com/bgarciamoura/neovim-0.10-config/issues
[license-shield]: https://img.shields.io/github/license/bgarciamoura/neovim-0.10-config.svg?style=for-the-badge
[license-url]: https://github.com/bgarciamoura/neovim-0.10-config/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/bgarciamoura
