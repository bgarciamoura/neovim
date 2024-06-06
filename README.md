OH, SHIT... HERE WE GO AGAIN!!!!

Yes, i know, you are tired of just see neovim configs here... BUT WHAT I CAN DO?!?!?! Create new neovim's configs is very addictive =P

And now, with neovim 0.10, i have a lot to change in my previous config, sooooo... why not start all over again??

Soooo... let's start with our folder structure, i decided to change the folder structure a little bit of my previous version. For this version i decided to try a modularizable version with each module taking care of what's it responsability.

Here's a simple example of how this folder's structure looks like:

~/.config/nvim/
│
├── init.vim               # Main configuration file that sources other files
├── autoload/
│   └── plug.vim           # Handles plugin management
│
├── colors/                # Contains color scheme files
│
├── settings/              # General settings
│   ├── options.vim        # General options like tab settings, line numbers, etc.
│   └── mappings.vim       # Key mappings for common actions
│
├── plugins/               # Holds plugin configurations
│   ├── nerdtree.vim       # Configuration for NERDTree plugin
│   └── fugitive.vim       # Configuration for Fugitive plugin
│
├── filetypes/             # Filetype-specific settings
│   ├── python.vim         # Settings specific to Python files
│   └── javascript.vim     # Settings specific to JavaScript files
│
├── after/                 # Settings that override default settings
│   ├── ftplugin/          # Filetype-specific overrides
│   │   ├── python.vim     # Overrides for Python files
│   │   └── javascript.vim # Overrides for JavaScript files
│   ├── plugin/            # Plugin-specific overrides
│   │   ├── nerdtree.vim   # Overrides for NERDTree plugin
│   │   └── fugitive.vim   # Overrides for Fugitive plugin
│   └── config.vim         # General overrides (e.g., mappings, options)
│
├── snippets/              # Contains snippet files for UltiSnips or other snippet plugins
│   └── python.snippets    # Snippets for Python files
│
├── syntax/                # Syntax highlighting customizations
│   └── mylang.vim         # Custom syntax highlighting for specific languages
│
└── README.md              # Documentation for the configuration

