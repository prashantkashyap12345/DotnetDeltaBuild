# DotnetDeltaBuild 🚀  
**A Git-aware .NET build tool that compiles only projects with unpushed changes**  
*(Save time by skipping unchanged projects!)*  

![GitHub license](https://img.shields.io/badge/platform-bash%20%7C%20zsh-blue)  
![Demo](https://github.com/prashantkashyap12345/DotnetDeltaBuild/raw/main/assets/demo.gif) *(Example GIF placeholder)*  

---

## 🔧 Installation  


### Quick Installation

#### **Bash**
```bash
curl -o ~/.dotnet_delta_build.bash https://github.com/prashantkashyap12345/DotnetDeltaBuild/blob/main/dotnet_delta_build.bash &&
echo "\nsource ~/.dotnet_delta_build.bash" >> ~/.bashrc &&
source ~/.bashrc
```

#### **Zsh**
```bash
curl -o ~/.dotnet_delta_build.bash https://github.com/prashantkashyap12345/DotnetDeltaBuild/blob/main/dotnet_delta_build.zsh &&
echo "\nsource ~/.dotnet_delta_build.bash" >> ~/.zshrc &&
source ~/.zshrc
```
### **Detailed Installation**

### **1. Download the Script**  
Choose your shell:  

#### **Bash**  
```bash
curl -o ~/.dotnet_delta_build.bash https://github.com/prashantkashyap12345/DotnetDeltaBuild/blob/main/dotnet_delta_build.bash
```

#### **Zsh**  
```bash
curl -o ~/.dotnet_delta_build.zsh https://github.com/prashantkashyap12345/DotnetDeltaBuild/blob/main/dotnet_delta_build.zsh
```

---

### **2. Add to Shell Config**  
#### **Bash** (`~/.bashrc` or `~/.bash_profile`)  
```bash
echo "\nsource ~/.dotnet_delta_build.bash" >> ~/.bashrc
```
<!--```bash
source ~/.dotnet_delta_build.bash
```-->

#### **Zsh** (`~/.zshrc`)  
```bash
echo "\nsource ~/.dotnet_delta_build.zsh" >> ~/.zshrc
```
<!--```bash
source ~/.dotnet_delta_build.zsh
``` -->

### **3. Reload Shell** 
#### **Bash**
```bash
echo "\nsource ~/.dotnet_delta_build.bash" >> ~/.bashrc
```
#### **Zsh**
```bash
echo "\nsource ~/.dotnet_delta_build.zsh" >> ~/.zshrc
``` 
<!--```bash
source ~/.bashrc  # Bash
source ~/.zshrc   # Zsh
```-->

---

## 🛠️ Commands  
| Command          | Description                              |
|------------------|------------------------------------------|
| `dnbgc`          | Builds projects with changes (verbose)   |
| `dnbgcq`         | Quiet mode (minimal output)              |
| `dnbgc-dry`      | Dry-run (show what would be built)       |

---

## 🚀 Usage  
### **1. Build Changed Projects**  
```bash
dnbgc
```
**Output:**  
```diff
🔍 Finding unpushed changes in 'feature/authentication'...
📝 Changed files:
  src/AuthService/Controllers/LoginController.cs
  src/Core/Models/User.cs

🔨 Building 2 projects:
  📦 src/AuthService/AuthService.csproj → ✅ Success
  📦 src/Core/Core.csproj → ✅ Success
📊 Results: Built 2 projects in 4.2s.
```

### **2. Quick Build (Silent)**  
```bash
dnbgcq
```
**Output:**  
```bash
Building AuthService...✅
Building Core...✅
✅ Built 2 projects in 3.8s.
```

### **3. Dry Run**  
```bash
dnbgc-dry
```
**Output:**  
```bash
🔍 Projects with unpushed changes:
  📦 src/AuthService/AuthService.csproj
  📦 src/Core/Core.csproj
```

---

## 📜 How It Works  
1. **Detects Changes**: Checks for:  
   - Unpushed commits  
   - Staged/unstaged changes  
2. **Maps to Projects**: Finds `.csproj` files containing changed files.  
3. **Smart Build**: Skips unaffected projects.  

---

## ⚠️ Troubleshooting  
| Issue                  | Fix                                      |
|------------------------|------------------------------------------|
| `Command not found`    | Verify `source` line in your shell config. |
| `No .csproj files`     | Run from the solution root directory.     |
| `Not a Git repo`       | Ensure you’re in a Git repository.        |

---

## 🤝 Contributing  
PRs welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).  

---

## 📄 License  
MIT © [Your Name](https://github.com/prashantkashyap12345)  

---

**🎉 Happy Coding!**  
*"Build less, ship more!"*  

--- 

### ✨ Enhancements Needed?  
- Add a real demo GIF under `assets/`.  
- Include CI/CD examples (GitHub Actions).  
- Add benchmarks (time saved vs. full rebuild).  

Let me know if you'd like to refine any section!
