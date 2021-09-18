begin
    function kube-context -a context -d "Displays or sets current Kube context"
        if test -z $context
            command kubectl config current-context
        else
            command kubectl config use-context $context
        end
    end

    alias kube-ctx kube-context
end
