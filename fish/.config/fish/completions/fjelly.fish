#!/bin/fish
# Fish completions for fjelly
# To use: copy this file to ~/.config/fish/completions/fjelly.fish

complete -c fjelly -f

# Main commands
complete -c fjelly -n "not __fish_seen_subcommand_from init workspace task idea context doctor help" -a "init" -d "Initialize a new workspace"
complete -c fjelly -n "not __fish_seen_subcommand_from init workspace task idea context doctor help" -a "workspace" -d "Workspace management commands"
complete -c fjelly -n "not __fish_seen_subcommand_from init workspace task idea context doctor help" -a "task" -d "Task management commands"
complete -c fjelly -n "not __fish_seen_subcommand_from init workspace task idea context doctor help" -a "idea" -d "Idea capture commands"
complete -c fjelly -n "not __fish_seen_subcommand_from init workspace task idea context doctor help" -a "context" -d "Context management"
complete -c fjelly -n "not __fish_seen_subcommand_from init workspace task idea context doctor help" -a "doctor" -d "System health check"
complete -c fjelly -n "not __fish_seen_subcommand_from init workspace task idea context doctor help" -a "help" -d "Show help"

# Global options
complete -c fjelly -s h -l help -d "Show help"
complete -c fjelly -s v -l verbose -d "Enable verbose output"
complete -c fjelly -l version -d "Show version information"
complete -c fjelly -l config -r -d "Use custom config file"
complete -c fjelly -s w -l workspace -r -d "Use specific workspace"
