#!/usr/bin/env ruby
# Written by Edwin Millan-Rodriguez

require 'prawn'
require 'open-uri'

num_extensions = 157
max_rows = 60
max_columns = 3

extensions = Array.new(num_extensions)
extensions = extensions.each_index.map { |i| ["Name#{i}", "#{i + 1234}"] }

columns = extensions.each_slice(max_rows).inject([]) { |cols,col| cols << col }
columns.fill([], columns.length...max_columns)
columns.each { |column| column.fill([" "," "], column.length...max_rows) }

data = columns.transpose.flatten!.each_slice(6).to_a

Prawn::Document.generate("template.pdf", page_size: "LEGAL", page_layout: :portrait) do
  font_size 24
  draw_text "Company Phone Directory", at: [175,890]
  font_size 9
  logo_url = './logo.png'
  image open(logo_url), width: 122, height: 56, at: [50,926]

  bounding_box([50,880],width: 450, height: 900) do
    header = [["Name","Extension"] * max_columns]
    text "Revision #{Time.now.strftime "%-m.%d.%Y"}", align: :right
    table(header + data, width: 450, position: :center, cell_style: {padding: 2}, row_colors: ["EBF0DE","FFFFFF"], header: true) do
      row(0).font_style = :bold
      row(0).text_color = "FFFFFF"
      row(0).background_color = "9BBA58"
    end
  end
end