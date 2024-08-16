function ollama-up -d 'Updates all Ollama models'
    for model in (ollama ls | tail -n +2 | string match -rg '(.+:[\w\d_-]+)')
        echo -s (set_color $fish_color_user) "updating $model" (set_color normal)
        command ollama pull $model
        or break
    end
end
