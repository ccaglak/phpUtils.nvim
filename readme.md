## phpUtils.nvim

Neovim PhpUtils - one step toward phpstorm
**

## Basic Usage

-   `:PhpMethod` generates undefined method in class
-   `:PhpClass` generates the undefined class, trait, interface with with proper namespace also creates namespace for the current file
-   `:PhpScripts` runs composer scripts
-   `:PhpNamespace` generates namespace for the file

## Install    -- no default keymaps

```lua

{  -- lazy
    'ccaglak/phpUtils.nvim',
    keys = {
        { "<leader>lm", "<cmd>PhpMethod<cr>"},
        { "<leader>lc", "<cmd>PhpClass<cr>"},
        { "<leader>ls", "<cmd>PhpScripts<cr>"},
        { "<leader>ln", "<cmd>PhpNamespace<cr>"},
    }
    dependencies = {
        "nvim-lua/plenary.nvim"
    }
}

```

## Requires

-   pleanery.nvim
-   nvim-treesitter (`:TSInstall php json`)
-   recommended

## Features to be added
- custom templates
- append to codeactions
- laravel artisan command center
- ability make method public/protected/private
- generate __contruct with types params
- getter/setters generaters ???????
- custom template per directory base :? in Controller directory, controller template is generated
- run tests (run all, filter, file, line)
- vim.ui.select and input overwrite telescope

## Known bugs
-   Let me know if you have any edge cases

## Check Out

Laravel Goto Blade/Components [larago.nvim](https://github.com/ccaglak/larago.nvim).
PHP Namespace Resolve [namespace.nvim](https://github.com/ccaglak/namespace.nvim).


## Inspired

-   by PHPStorm

## License MIT
