; extends

(pair
  key: (property_identifier) @key (#eq? @key "styles")
  value: [
          (string (string_fragment) @injection.content)
          (template_string (string_fragment) @injection.content)
          (array([
                 (string (string_fragment) @injection.content)
                 (template_string(string_fragment) @injection.content)
                 ]))]
  (#set! injection.language "css"))
