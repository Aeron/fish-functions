function pip-reset -d 'Removes local Python packages, except for a few vital ones'
    pip uninstall -y (pip freeze | grep --invert-match "pip|setuptools|wheel")
end
