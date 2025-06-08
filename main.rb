require 'cgi'

input = File.read("input.txt")

# tokens = {"regex" => "string"}
tokens = {
  /\/\*.*?\*\//m => 'color: green;',          # multi-line comments /* ... */
  /\/\/.*$/ => 'color: green;',               # single-line comments // ...
  /"(\\.|[^"])*"/ => 'color: blue;',          # double-quoted strings "Hello"
  /'(\\.|[^'])+'/  => 'color: blue;',         # single-quoted strings 'Hello'
  /#include\s*<[^>]+>/ => 'color: #800080; font-weight: bold;',  # Matches #include <...>
  /\b(?:if|else|return|for|while|class|struct|private|public|protected|void|bool|true|false|using|namespace|std|cout|endl|const)\b/ => 'color: purple;',  # Matches C++ keywords
  /\b(?:int|float|double|bool|char|void|long|unsigned|signed|string|vector)\b/ => 'color: teal;',  # C++ data types
  /\b\d+(\.\d+)?\b/ => 'color: orange;',      # numbers
  /\+\+|--|==|!=|<=|>=|&&|\|\||<<|>>|[+\-*\/=<>!]/ => 'color: red;',  # operators
  /[{}()\\[\\];,:]/ => 'color: brown;',       # brackets, parentheses, and punctuation
  /\b[a-zA-Z_][a-zA-Z0-9_]*\b/ => 'color: #1E3D59;',  # identifiers (variable names, function names)
}

html = input.gsub(Regexp.union(tokens.keys)) do |match|
  style = nil

  tokens.each do |regex, estilo|
    if match =~ regex
      style = estilo
      break
    end
  end  
  "<span style=\"#{style}\">#{CGI.escapeHTML(match)}</span>"
end

File.open('out.html', 'w') do |f|
  f.puts <<~HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>Highlighted C++ Code</title>
    </head>
    <body>
      <pre style="font-family: monospace; white-space: pre;">#{html}</pre>
    </body>
    </html>
  HTML
end

puts "File created"
