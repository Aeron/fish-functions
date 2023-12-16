function pyclean -d 'Cleans Python cache and pre-compiled modules in CWD'
    find . | grep -E '(__pycache__|\.pyc|\.pyo$)' | xargs rm -rf
end
