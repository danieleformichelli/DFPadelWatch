#!/bin/zsh -x

# Close Xcode if opened
osascript -l JavaScript -e 'function run(a){Application("Xcode").workspaceDocuments().forEach(d=>{if(d.path() == null || d.path().includes(a))d.close()})}' $(pwd);

# Fetch external dependencies
tuist fetch

# Warm cache
tuist cache warm --xcframeworks

# Generate and open project
tuist generate --xcframeworks