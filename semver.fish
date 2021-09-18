function semver -d 'Evaluates an actual semantic version for a Git Flow repo'
    set branch_develop 'develop/*'
    set regex_release '(release/*|hotfix/*)'
    set regex_feature '(finishes|delivers|implements|closes)\ #[0-9]+'
    set regex_fix '(fixes|resolves)\ #[0-9]+'
    set regex_semver '[0-9]+\.[0-9]+\.[0-9]+'

    set last_release (
        git log -E \
        --grep=$regex_release --branches=$branch_develop \
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
        set last_tag (
            git log \
            --grep="Merge tag" --branches=$branch_develop \
            --show-notes --oneline \
            $last_release_revision_range | head -n 1
        )

        set last_tag_revision (string sub --length 7 $last_tag)

        if test -z $last_tag_revision
            set last_feature_revision_range HEAD
        else
            set last_feature_revision_range $last_tag_revision..HEAD
        end
    else
        set last_feature_revision_range $last_feature_revision..HEAD
    end

    set fixes_since_last_feature (
        git log -i -E \
        --grep=$regex_fix --branches=$branch_develop \
        --show-notes --oneline \
        $last_feature_revision_range | wc -l
    )

    if test -z $last_release_version_info[1]
        set version_major 0
    else
        set version_major $last_release_version_info[1]
    end

    if test $last_release_version_info[2] -eq 0
        set version_minor $features_since_last_release
    else
        set version_minor (
            math $last_release_version_info[2] + $features_since_last_release
        )
    end

    if test $version_minor -gt $last_release_version_info[2]
        set version_patch $fixes_since_last_feature
    else
        set version_patch (
            math $last_release_version_info[3] + $fixes_since_last_feature
        )
    end

    set version_major (string trim $version_major)
    set version_minor (string trim $version_minor)
    set version_patch (string trim $version_patch)

    if contains -- -v $argv
        echo "Last release revision:" (string trim $last_release_revision)
        echo "Last feature revision:" (string trim $last_feature_revision)
        echo "Added minor:" (string trim $features_since_last_release)
        echo "Added patch:" (string trim $fixes_since_last_feature)
    end

    if contains -- -l $argv
        git log -i -E \
        --grep="#[0-9]+" --branches=$branch_develop \
        --reverse $last_release_revision..HEAD | grep -i -E "#[0-9]+"
    end

    echo $last_release_version "→" (
        string join . $version_major $version_minor $version_patch
    )
end
