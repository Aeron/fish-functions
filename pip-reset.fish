function pip-reset -d 'Removes local Python packages, except for a few vital ones'
    # pip itself is never included in freeze results
    pip uninstall -y (pip freeze | grep --invert-match "setuptools|wheel")
end
