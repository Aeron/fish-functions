function kube-ctx -a context -d "Displays or sets current Kube context"
    if test -z $context
        command kubectl config current-context
    else
        command kubectl config use-context $context
    end
end
