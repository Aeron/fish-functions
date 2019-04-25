function semver -d 'Evaluates an actual semantic version for Git Flow repo'
    set _branch_develop 'develop/*'
    set _branch_release 'release/*'
    set _regex_feature '(finishes|delivers)\ #[0-9]+'
    set _regex_fix 'fixes\ #[0-9]+'
    set _regex_semver '[0-9]+\.[0-9]+\.[0-9]+'

    set last_release (
        git log -E \
        --grep=$_branch_release --branches=$_branch_develop \
        --show-notes --oneline \
        HEAD | head -n 1
    )

    set last_release_revision (string sub --length 7 $last_release)
    set last_release_version (string match --regex $_regex_semver $last_release)
    set last_release_version_info (string split . $last_release_version)

    set features_since_last_release (
        git log -i -E \
        --grep=$_regex_feature --branches=$_branch_develop \
        --show-notes --oneline \
        $last_release_revision..HEAD | wc -l
    )

    set last_feature (
        git log -i -E \
        --grep=$_regex_feature --branches=$_branch_develop \
        --show-notes --oneline \
        $last_release_revision..HEAD | head -n 1
    )

    set last_feature_revision (string sub --length 7 $last_feature)

    set fixes_since_last_feature (
        git log -i -E \
        --grep=$_regex_fix --branches=$_branch_develop \
        --show-notes --oneline \
        $last_feature_revision..HEAD | wc -l
    )

    set actual_release_version (
        string join . $last_release_version_info[1] \
        (math $last_release_version_info[2] + $features_since_last_release) \
        (math $last_release_version_info[3] + $fixes_since_last_feature)
    )

    # echo "Last release revision:" (string trim $last_release_revision)
    # echo "Last feature revision:" (string trim $last_feature_revision)
    # echo "Minor:" (string trim $features_since_last_release)
    # echo "Patch:" (string trim $fixes_since_last_feature)
    echo $last_release_version "→" $actual_release_version
end
