# Brand Template JSONB Schema (Discovered 2025-10-25)

## detection_patterns (array of regex strings)
Purpose: Identify brand from OCR text
Example: ["V\\d{4}", "vivo"]
- Array of regex patterns (case-insensitive matching recommended)
- If ANY pattern matches → brand detected

## extraction_patterns (object: field_name → regex)
Purpose: Extract structured data from OCR text
Example: {
  "ean": "(\\d{13}|\\d{12})",
  "ram": "(\\d+)\\s*GB",
  "color": "Color[:\\s]*([\\w\\s]+?)(?:\\n|$)",
  "imei1": "IMEI1?[:\\s]*(\\d{15})",
  "model_code": "V\\d{4}"
}
- Key: Field name in products table
- Value: Regex with capture group (first group extracted)
- Backslashes must be escaped in JSON

## mandatory_fields (array of field names)
Purpose: Validation - ensure critical fields extracted
Example: ["product_code", "imei1"]
- Must be subset of extraction_patterns keys
- Sale blocked if mandatory fields missing

## Design Decisions for /addtemplate:
1. Multi-step conversational flow (not single command)
2. Validate regex syntax before saving
3. Test pattern against sample OCR text
4. Priority auto-assigned (max+1) or user-specified
