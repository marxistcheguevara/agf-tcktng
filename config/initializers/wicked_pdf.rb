# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md

WickedPdf.config = {
    # Path to the wkhtmltopdf executable: This usually isn't needed if using
    # one of the wkhtmltopdf-binary family of gems.
    #  :exe_path => 'C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe',
    #:orientation => 'Landscape'
    #:height =>250,
    #:width =>100
    #   or
    #exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')
    :margin =>  {
        top:                0,                     # default 10 (mm)
        bottom:             0,
        left:               0,
        right:              0
    },
    page_size:                      'Letter',
    page_height:                    200,
    page_width:                     100
    # Layout file to be used for all PDFs
    # (but can be overridden in `render :pdf` calls)
    # layout: 'pdf.html',
}
