module ApplicationHelper
  require 'barby'
  require 'barby/barcode/code_128'
  require 'barby/outputter/png_outputter'
  def wicked_pdf_image_tag_for_public(img, options={})
    if img[0] == "/"
      new_image = img.slice(1..-1)
      image_tag "file://#{Rails.root.join('public', new_image)}", options
    else
      image_tag img
    end
  end

  def current_cl(tp)
    return 'active' if request.original_url.include?tp
    ''
  end

end
