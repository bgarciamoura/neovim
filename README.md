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
        <li>
            <a href="#lazygit">LazyGit</a>
        </li>
        <li>
            <a href="#nvim-treesitter">Nvim Treesitter</a>
        </li>
        <li>
            <a href="#nvim-web-devicons">Nvim Web Devicons</a>
            <ul>
                <li>
                    <a href="#nvim-material-icon">Nvim Material Icon</a>
                </li>
            </ul>
        </li>
        <li>
            <a href="#nvim-telescope">Nvim Telescope</a>
            <ul>
                <li>
                    <a href="#telescope-themes">Telescope Themes</a>
                </li>
            </ul>
        </li>
        <li>
            <a href="#nvim-highlight-colors">Nvim Highlight Colors</a>
        </li>
        <li>
            <a href="#nvim-neo-tree">Nvim Neo Tree</a>
        </li>
        <ul>
            <li>
                <a href="#nui">NUI</a>
            </li>
        </ul>
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
│    │   │
│    │   ├── plugin/            # Plugin-specific overrides
│    │   │   ├── nerdtree.lua   # Overrides for NERDTree plugin
│    │   │   └── fugitive.lua   # Overrides for Fugitive plugin
│    │   └── init.lua           # Default export file
│    │ 
│    ├── autoload/              # Settings that are triggered when open neovim
│    │   └── init.lua           # Default export file including the lazy plugin manager start config
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
│    │   ├── lazy.lua           # Lazy plugin manager autoload settings
│    │   ├── whichkey.lua       # Shows your keymaps in a navegatable panel
│    │   └── treesitter.lua     # Configuration for Nvim-Treesitter
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

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Which Key

[Folke's Which Key](https://github.com/folke/which-key.nvim)

From a Vim/Neovim monster, AKA Folke, Which Key is a amazing plugin that shows a panel with your defined key bindings.

For people as me, that almost forgot everything, this plugin is gold cuz, even if you forgot which key you defined, it can show for you how can you do something.

In the plugin configuration file, located on ```~/.config/nvim/lua/plugins/whichkey.lua```, you can define how the plugin popup will show, new key bindings for every action you want and the plugin behavior.

For example, let's say that you want to save your file without typing ```:w<CR>``` in the command pallete, you can configure which-key to do that by pressing ```<leader>s```, then you can see this on which key popup, even if you forget this again, just by pressing the ```<leader>``` key

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### LazyGit

[Oh my God, how I love this plugin](https://github.com/kdheepak/lazygit.nvim)

For the most part of the world, using Git commands it's just type commands on CLI, others uses GUI as Github Desktop, but, as a Neovim user, why not to use a CLI/GUI interface inside Neovim?!?!?!?!

And than was born LazyGit for Neovim, this is an amazing plugin that utilize the terminal plugin LazyGit inside Neovim interface.

It's one of the best way of deal with GIT inside Neovim, IMO.

To use it you'll have to install the [LazyGit plugin](https://github.com/jesseduffield/lazygit) for your terminal and [Plenary](https://github.com/nvim-lua/plenary.nvim) that is a plugin to deal with some Neovim Lua Code.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Nvim Treesitter

[Don't be colorblind as me](https://github.com/nvim-treesitter/nvim-treesitter)

Oh, what's is a world without all its colors?!?!

For me, as a colorblind person, its my a normal world, for the rest of the world its a torture, soooo, let's install Nvim-Treesitter and put some colors in the code

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Nvim Web Devicons

[Iconic Icons](https://github.com/nvim-tree/nvim-web-devicons)

Who don't like to see icons, beautiful icons, everywhere?? If you don't, i fell sorry for you.

For me, icons is one fantastic things in the computer world and i love to see icons on my code editor, sooooo.... Nvim-Web-Devicons helps me to visualize what I dreamed about, LOL!!!

<p align="right">(<a href="#readme-top">back to top</a>)</p>

#### Nvim Material Icon

[Material things, they come and go](https://github.com/DaikyXendo/nvim-material-icon)

Who never use something with material theme or material icons???

Its just fair to use here in Neovim, cuz that we install this awesome plugin.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Nvim Telescope

[Keep Searchin'](https://github.com/nvim-telescope/telescope.nvim)

Tired of searching for a file, for a open buffer or just for a simple word inside your gigantic project???

So Telescope is just for you!!!

With it you can just grep for all files in the project, looking for a word, for functions or whatever you want. With the right configuration you can even replace code on all files from just one place.

Dig into Telescope documentation and you'll enter in the rabbit hole.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

#### Telescope Themes

[Make me beatiful](https://github.com/andrew-george/telescope-themes)

We already has Telescope to show us the installed themes, why not change and persist the theme that we choose???

For that i've install this awesome plugin, that gives us the ability to persist the chosen theme.

I just made one adjust in the plugin code. The plugin store the chosen theme on `~/.config/nvim/lua/current-theme.lua` and then, you'll have to import the file on your Neovim configuration, so I made a change in the plugin's function that create this file to the path be another one - `~/.config/nvim/lua/colors/current-theme.lua`


<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Nvim Highlight Colors

[I can see clearly now...](https://github.com/brenoprata10/nvim-highlight-colors)

It's a pain in the a.. when you're typing a color and can't see wich is the color you typed, to solve that we'll use nvim highlight colors.

This plugins use the background of the typed color to show a block with the actual color, making so much easier to find the desired color.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Nvim Neo Tree

[Look to Yggdrasil](https://github.com/nvim-neo-tree/neo-tree.nvim)

Ntree is just fine, but at this point, I already have colorschemes, icons, even the material icons. So Ntree become a little untasty for me and i decided to install a new tree, or must I say a NEO TREE.

Neo-tree is a little less performatic than nvim-tree, but it's more beautiful to me.

The only trowback to me is that it has one dependency plus Plenary, but I'll take my chances LOL.

[For reference, here is the defaults for lua config](https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/defaults.lua)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

#### NUI

[So you like windows...](https://github.com/MunifTanjim/nui.nvim)

Nui is a powefull plugin that allows another plugins to create new windows, even in linux, to show content.

Here it will be used, primary, by Neo Tree as a way to preview the file before open it.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

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
