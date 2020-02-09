Feature: Config
    In order to use the reviewer, I need to configure API keys, URLs, and more

    Scenario: Add a configuration
        When I run `big_differ config add --name config1 --service github --key abc123 --url http://my.code.lives.here`
        Then the output should contain "Added configuration for config1"
    
    Scenario: Delete a configuration
        When I run `big_differ config delete --name config1`
        Then the output should contain "Deleted configuration for config1"
        