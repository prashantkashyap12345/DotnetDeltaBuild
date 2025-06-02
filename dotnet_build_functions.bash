# Save this to ~/.dotnet_build_functions.bash
# Then add to your .bashrc: source ~/.dotnet_build_functions.bash

# Build only projects with unpushed Git changes
dnbgc() {
    local start_time=$(date +%s.%N)
    local current_branch=$(git branch --show-current 2>/dev/null)
    local remote_branch="origin/$current_branch"
    local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [ -z "$current_branch" ] || [ -z "$repo_root" ]; then
        echo "❌ Not in a Git repository"
        return 1
    fi

    echo "🔍 Finding unpushed changes in '$current_branch'..."

    # Check if remote branch exists
    if ! git ls-remote --exit-code --heads origin "$current_branch" >/dev/null 2>&1; then
        echo "  ℹ️ Remote branch doesn't exist yet - comparing against origin/HEAD"
        remote_branch="origin/HEAD"
    fi

    # Get all unpushed changes
    local changed_files=$({
        git diff --name-only "$remote_branch" HEAD 2>/dev/null
        git diff --name-only --cached 2>/dev/null
        git diff --name-only 2>/dev/null
    } | sort -u)

    if [ -z "$changed_files" ]; then
        echo "✅ No unpushed changes detected."
        return 0
    fi

    echo "📝 Changed files:"
    echo "$changed_files" | sed 's/^/  /'
    echo

    # Find all .csproj files in the repo
    local all_projects=$(find "$repo_root" -name "*.csproj" -type f)

    if [ -z "$all_projects" ]; then
        echo "❌ No .csproj files found."
        return 1
    fi

    local projects_to_build=()
    local tmp_file=$(mktemp)

    # Mark projects with changes
    while IFS= read -r project; do
        local project_dir=$(dirname "$project")
        local has_changes=false

        while IFS= read -r changed_file; do
            if [[ "$repo_root/$changed_file" == "$project_dir"/* ]]; then
                has_changes=true
                break
            fi
        done <<< "$changed_files"

        if [ "$has_changes" = true ]; then
            projects_to_build+=("$project")
            echo "$project" >> "$tmp_file"
        fi
    done <<< "$all_projects"

    # Also check for changes in project files themselves
    while IFS= read -r changed_file; do
        if [[ "$changed_file" == *.csproj ]]; then
            local project="$repo_root/$changed_file"
            if [ -f "$project" ] && ! grep -qFx "$project" "$tmp_file"; then
                projects_to_build+=("$project")
            fi
        fi
    done <<< "$changed_files"

    rm -f "$tmp_file"

    if [ ${#projects_to_build[@]} -eq 0 ]; then
        echo "ℹ️ No projects with unpushed changes."
        return 0
    fi

    echo "🔨 Building ${#projects_to_build[@]} projects with changes (Debug configuration):"
    local build_count=0
    local failed_builds=()

    for project in "${projects_to_build[@]}"; do
        local relative_path=${project#$repo_root/}
        echo "  📦 $relative_path"
        if dotnet build "$project"; then
            echo "  ✅ Success"
            ((build_count++))
        else
            echo "  ❌ Failed"
            failed_builds+=("$relative_path")
        fi
    done

    local end_time=$(date +%s.%N)
    local elapsed_time=$(echo "$end_time - $start_time" | bc)

    echo "📊 Results:"
    echo "  ✅ Built: $build_count projects"
    echo "  ⏱️  Total time: ${elapsed_time%.*} seconds"

    if [ ${#failed_builds[@]} -gt 0 ]; then
        echo "  ❌ Failed (${#failed_builds[@]}):"
        for failed in "${failed_builds[@]}"; do
            echo "    $failed"
        done
        return 1
    fi

    return 0
}

dnbgcq() {
    local start_time=$(date +%s.%N)
    local current_branch=$(git branch --show-current 2>/dev/null)
    local remote_branch="origin/$current_branch"
    local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [ -z "$current_branch" ] || [ -z "$repo_root" ]; then
        echo "❌ Not in a Git repository" >&2
        return 1
    fi

    # Check if remote branch exists
    if ! git ls-remote --exit-code --heads origin "$current_branch" >/dev/null 2>&1; then
        remote_branch="origin/HEAD"
    fi

    local changed_files=$({
        git diff --name-only "$remote_branch" HEAD 2>/dev/null
        git diff --name-only --cached 2>/dev/null
        git diff --name-only 2>/dev/null
    } | sort -u)

    if [ -z "$changed_files" ]; then
        echo "✅ No unpushed changes to build."
        return 0
    fi

    local all_projects=$(find "$repo_root" -name "*.csproj" -type f)
    local built_count=0
    local failed=false

    while IFS= read -r project; do
        local project_dir=$(dirname "$project")
        local has_changes=false

        while IFS= read -r changed_file; do
            if [[ "$repo_root/$changed_file" == "$project_dir"/* ]] || [[ "$changed_file" == *.csproj ]]; then
                has_changes=true
                break
            fi
        done <<< "$changed_files"

        if [ "$has_changes" = true ]; then
            local project_name=$(basename "$project" .csproj)
            echo -n "Building $project_name..."
            if dotnet build "$project" >/dev/null 2>&1; then
                echo "✅"
                ((built_count++))
            else
                echo "❌"
                failed=true
            fi
        fi
    done <<< "$all_projects"

    local end_time=$(date +%s.%N)
    local elapsed_time=$(echo "$end_time - $start_time" | bc)

    if [ "$failed" = true ]; then
        echo "Build failed for some projects." >&2
        return 1
    fi

    echo "✅ Built $built_count projects in ⏱️ ${elapsed_time%.*} seconds."
    return 0
}

dnbgc-dry() {
    local current_branch=$(git branch --show-current 2>/dev/null)
    local remote_branch="origin/$current_branch"
    local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [ -z "$current_branch" ] || [ -z "$repo_root" ]; then
        echo "❌ Not in a Git repository" >&2
        return 1
    fi

    echo "🔍 Projects with unpushed changes in '$current_branch':"

    # Get changed files
    local changed_files=$(git diff --name-only "$remote_branch" 2>/dev/null)
    changed_files+=$'\n'$(git diff --name-only --cached 2>/dev/null)
    changed_files+=$'\n'$(git diff --name-only 2>/dev/null)
    changed_files=$(echo "$changed_files" | grep -v '^$' | sort -u)

    if [ -z "$changed_files" ]; then
        echo "  None (no unpushed changes)"
        return 0
    fi

    echo "  Changed files detected:"
    echo "$changed_files" | sed 's/^/    /'

    # Find all .csproj files
    local all_projects=$(find "$repo_root" -name "*.csproj" -type f)
    if [ -z "$all_projects" ]; then
        echo "  No .csproj files found!" >&2
        return 1
    fi

    local found_projects=false

    while IFS= read -r project; do
        local project_dir=$(dirname "$project")
        local has_changes=false

        while IFS= read -r changed_file; do
            if [[ "$repo_root/$changed_file" == "$project_dir"/* ]]; then
                has_changes=true
                break
            fi
        done <<< "$changed_files"

        if [ "$has_changes" = true ]; then
            echo "  📦 ${project#$repo_root/}"
            found_projects=true
        fi
    done <<< "$all_projects"

    if [ "$found_projects" = false ]; then
        echo "  No projects with unpushed changes found (but changes exist)"
        echo "  This might happen if:"
        echo "  1. Changed files aren't under any .csproj directory"
        echo "  2. The .csproj files are in unexpected locations"
    fi
}
