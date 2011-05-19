module ApplicationHelper
	def file_size_from_bytes(size)
		in_kb = (size.to_f / 1024)
		in_kb = 1 if in_kb < 1.0
		if in_kb > 1024
			"#{number_with_precision((in_kb / 1024), :precision => 2)} MB"
		else
			"#{in_kb.round} KB"
		end
	end
	
	def document_icon_for(document, small = false)
		file = case document.extension
			when 'docx'
				'doc'
			when 'xlsx'
				'xls'
			when 'pptx'
				'ppt'
			when 'jpeg'
				'jpg'
			else
				document.extension
		end
		small ? image_tag("docs/small/#{file}.png") : image_tag("docs/#{file}.png")
	end
	
	def loading_icon
		image_tag('loading.gif', :class => 'loading none')
	end
end
