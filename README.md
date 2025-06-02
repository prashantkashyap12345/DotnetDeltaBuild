# DotnetDeltaBuild
Git-Aware .NET Build Tools Setup Guide
For Bash & Zsh Users

These scripts (dnbgc, dnbgcq, and dnbgc-dry) help you build only the .NET projects with unpushed Git changes (committed, staged, or unstaged). This saves time by avoiding unnecessary rebuilds.

📥 Installation Instructions
1. Download the Scripts
Choose the correct version for your shell:

For Zsh Users
bash
curl -o ~/.dotnet_build_functions.zsh https://gist.githubusercontent.com/yourusername/yourgistid/raw/dotnet_build_functions.zsh
For Bash Users
bash
curl -o ~/.dotnet_build_functions.bash https://gist.githubusercontent.com/yourusername/yourgistid/raw/dotnet_build_functions.bash
(Replace the URL with the actual raw link if hosting these scripts elsewhere.)

2. Add to Your Shell Configuration
Zsh (macOS/Linux)
Open ~/.zshrc and add:

bash
source ~/.dotnet_build_functions.zsh
Bash (macOS/Linux)
Open ~/.bashrc (or ~/.bash_profile on macOS) and add:

bash
source ~/.dotnet_build_functions.bash
Apply Changes
Reload your shell:

bash
source ~/.zshrc  # For Zsh
# OR
source ~/.bashrc  # For Bash
🛠️ Available Commands
Command	Description
dnbgc	Builds all projects with unpushed changes (verbose output)
dnbgcq	Quiet mode (minimal output, faster)
dnbgc-dry	Dry-run (shows which projects would be built)
🚀 Usage Examples
1. Build All Changed Projects
bash
dnbgc
Output:

🔍 Finding unpushed changes in 'feature/new-endpoint'...
📝 Changed files:
  src/API/Controllers/UserController.cs
  src/Domain/Models/User.cs

🔨 Building 2 projects with changes:
  📦 src/API/API.csproj
  ✅ Success
  📦 src/Domain/Domain.csproj
  ✅ Success

📊 Results:
  ✅ Built: 2 projects
  ⏱️  Total time: 5 seconds
2. Quick Build (Minimal Output)
bash
dnbgcq
Output:

Building API...✅
Building Domain...✅
✅ Built 2 projects in ⏱️ 4 seconds.
3. Check What Would Be Built (Dry Run)
bash
dnbgc-dry
Output:

🔍 Projects with unpushed changes in 'feature/new-endpoint':
  Changed files detected:
    src/API/Controllers/UserController.cs
    src/Domain/Models/User.cs

  📦 src/API/API.csproj
  📦 src/Domain/Domain.csproj
🔄 Updating the Scripts
If improvements are made, update them with:

Zsh
bash
curl -o ~/.dotnet_build_functions.zsh https://new-url.zsh
source ~/.zshrc
Bash
bash
curl -o ~/.dotnet_build_functions.bash https://new-url.bash
source ~/.bashrc
⚠️ Troubleshooting
1. "Command not found" after installation?
Ensure you sourced your shell config (source ~/.zshrc or source ~/.bashrc).

Check if the file was saved in the correct location (~/.dotnet_build_functions.zsh or ~/.dotnet_build_functions.bash).

2. "Not in a Git repository" error?
Run the command inside a Git repo.

3. "No .csproj files found"?
Ensure you’re in the root of a .NET solution.

🎉 Enjoy Faster Builds!
These tools help you build only what changed, saving time in large projects.

Let your team know if you find issues or improvements! 🚀

Happy Coding! 💻🔥
