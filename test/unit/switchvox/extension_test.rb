require "test_helper"
require "json"

require "switchvox/extension"
module Switchvox
  class ExtensionTest < Minitest::Test
    def setup
      @subject = Extension.new(parsed_extension_options)
    end

    def test_no_options
      @subject = Extension.new
      assert_equal "unknown", @subject.name
      assert_equal "0000", @subject.ext
    end

    def test_name
      assert_equal "John Doe", @subject.name
    end

    def test_extension
      assert_equal "1234", @subject.ext
    end

    private
    def parsed_extension_options
      return parsed_response["response"]["result"]["extensions"]["extension"]
    end

    def parsed_response
      return JSON.parse(raw_response)
    end

    def raw_response
      return <<-JSON
      {
        "response" : {
          "method" : "switchvox.extensions.search",
          "result" : {
            "extensions" : {
              "page_number" : "1",
              "total_pages" : "1",
              "items_per_page" : "500",
              "total_items" : "1",
              "extension" : {
                "can_dial_from_ivr" : "1",
                "account_id" : "1122",
                "display" : "John Doe",
                "date_created" : "2009-01-28 21:34:29",
                "type" : "virtual",
                "type_display" : "Virtual Extension",
                "first_name" : "John",
                "last_name" : "Doe",
                "email_address" : "",
                "template_id" : "1",
                "template_name" : "Default",
                "number" : "1234",
                "status" : "1"
              }
            }
          }
        }
      }
      JSON
    end
  end
end
