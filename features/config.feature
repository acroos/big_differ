Feature: Config
    In order to use the reviewer, I need to configure API keys, URLs, and more

    Scenario: Add an API key
        When I run `big_differ config --key name:value`
        Then the output should contain "Key added: 'name: value'"
    
    Scenario: Remove an API key
        When I run `big_differ config --key name:value`
        Then the output should contain "Key added: 'name: value'"
        When I run `big_differ config --rmkey name`
        Then the output should contain "Key removed: 'name'"
    
    Scenario: Add a URL
        When I run `big_differ config --url my.code.lives.here`
        Then the output should contain "URL added: 'my.code.lives.here'"
    
    Scenario: Remove a URL
        When I run `big_differ config --url my.code.lives.here`
        Then the output should contain "URL added: 'my.code.lives.here'"
        When I run `big_differ config --rmurl my.code.lives.here'
        Then the output should contain "URL removed: 'my.code.lives.here'"