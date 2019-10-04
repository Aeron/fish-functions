function semver -d 'Evaluates an actual semantic version for Git Flow repo'
    set branch_develop 'develop/*'
    set branch_release 'release/*'
    set regex_feature '(finishes|delivers|implements|closes)\ #[0-9]+'
    set regex_fix '(fixes|resolves)\ #[0-9]+'
    set regex_semver '[0-9]+\.[0-9]+\.[0-9]+'

    set last_release (
        git log -E \
        --grep=$branch_release --branches=$branch_develop \
        --show-notes --oneline \
        HEAD | head -n 1
    )

    set last_release_revision (string sub --length 7 $last_release)

    if test -z $last_release_revision
        set last_release_revision_range HEAD
    else
        set last_release_revision_range $last_release_revision..HEAD
    end

    set last_release_version (string match --regex $regex_semver $last_release)

    if test -z $last_release_version
        set last_release_version "0.0.0"
    end

    set last_release_version_info (string split . $last_release_version)

    set features_since_last_release (
        git log -i -E \
        --grep=$regex_feature --branches=$branch_develop \
        --show-notes --oneline \
        $last_release_revision_range | wc -l
    )

    set last_feature (
        git log -i -E \
        --grep=$regex_feature --branches=$branch_develop \
        --show-notes --oneline \
        $last_release_revision_range | head -n 1
    )

    set last_feature_revision (string sub --length 7 $last_feature)

    if test -z $last_feature_revision
        set last_feature_revision_range HEAD
    else
        set last_feature_revision_range $last_feature_revision..HEAD
    end

    set fixes_since_last_feature (
        git log -i -E \
        --grep=$regex_fix --branches=$branch_develop \
        --show-notes --oneline \
        $last_feature_revision_range | wc -l
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
