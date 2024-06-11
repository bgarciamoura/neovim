OH, SHIT... HERE WE GO AGAIN!!!!

Yes, i know, you are tired of just see neovim configs here... BUT WHAT I CAN DO?!?!?! Create new neovim's configs is very addictive =P

And now, with neovim 0.10, i have a lot to change in my previous config, sooooo... why not start all over again??

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
│    │   ├── nerdtree.lua       # Configuration for NERDTree plugin
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
