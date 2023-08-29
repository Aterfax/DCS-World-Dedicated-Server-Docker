# DCS-World-Dedicated-Server-Docker Troubleshooting

## The server won't start?

If this is the first time you've started the server and you have not logged in yet, you will need to login, but the login window will be hidden behind the DCS splash screen. Right click on the Login window in the task bar and click move. It should now be visible for you to login to.

It's recommended to save your credentials and enable autologin to avoid this confusion in future.

If your server is still not starting, have you installed at least 1 terrain module? Make sure you have at least 1 installed or the server will be unable to load and run any mission files.


## Paths or executables aren't working right when I paste them into the terminal to do things!

The Linux bash terminal is sensitive to white spaces and special characters when dealing with paths or executables. If you're encountering issues when pasting paths or executable commands into the terminal, consider the following:

- **Whitespace Issues:** Paths with spaces should be enclosed in quotes to ensure the terminal treats them as a single entity. For example: ``cd "/path with spaces"``.

- **Escape Special Characters:** Special characters like spaces, tabs, and symbols need to be escaped using a backslash ``(`\`)`` to be interpreted correctly. For instance: ``file\ with\ spaces.txt``.

- **Environment Variables:** If you're using environment variables in paths or commands, ensure they are properly defined and spelled. Use the ``echo $VARIABLE_NAME`` command to verify their values.

- **Quotes and Apostrophes:** Be cautious when copying commands from websites, as they might use fancy quotes or apostrophes that the terminal doesn't recognize. Replace them with regular single or double quotes.

- **Quoting and Bash Variables:**

    - When dealing with bash variables within paths or commands, be aware of the differences between single and double quoting.

    - **Single Quotes:** ``(')`` Anything enclosed in single quotes is treated as a literal string. Bash variables within single quotes are not expanded, meaning their values are not substituted. 

    - **Double Quotes:** ``(")`` Double quotes allow for variable expansion. When a variable is enclosed within double quotes, its value is substituted in the string.

    - Caution: While double quotes allow variable expansion, they might also cause unintended expansions or interpretations of special characters. If you want to preserve the exact contents of a variable, especially if it includes special characters, consider using single quotes.

- **Check Paths:** Verify that the paths you are pasting are accurate and exist on your system. A single typo can lead to command failures.
  
- **Copy-Paste Accuracy:** Sometimes, when copying and pasting from various sources, invisible characters or formatting issues might be carried over. Try pasting the command into a text editor first to ensure it appears as expected before pasting it into the terminal.

- **Multi-line Commands:** If you're pasting multi-line commands, ensure that each line is complete and accurate before pressing Enter.

Remember that the Linux terminal is case-sensitive, so ensure proper capitalization in paths and commands. If you're still facing issues, providing specific details about the error messages or commands you're trying to execute can help others assist you more effectively.