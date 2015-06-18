module Dragonfly
  module ImageMagick
    class AvatarGenerator

      include Configurable
      include Utils

      def initial_avatar(string, opts={})
        opts = HashWithCssStyleKeys[opts]
        args = []
        
        # defaults
        format = opts[:format] || :png
        background = opts[:background_color] ? "##{opts[:background_color]}" : '#000000'
        color = opts[:color] ? "##{opts[:color]}" : '#FFFFFF'
        size = opts[:size] || '120x120'

        text = (string.split(/\s/)- ["", nil]).map { |t| t[0].upcase }.slice(0, 3).join('')

        w, h = size.split('x').map { |d| d.to_i }
        h ||= w

        font_size = ( w / [text.length, 2].max ).to_i

        # Settings
        args.push("-gravity Center")
        args.push("-antialias")
        args.push("-pointsize #{font_size}")
        args.push("-font \"#{opts[:font]}\"") if opts[:font]
        args.push("-family '#{font_family}'") if opts[:font]
        args.push("-fill #{color}")
        args.push("-background #{background}")
        args.push("label:#{text}")

        tempfile = convert(nil, args.join(' '), format)

        args = args.slice(0, args.length - 2)
        args.push("-size #{w}x#{h}")
        args.push("xc:#{background}")
        args.push("-annotate 0x0 #{text}")
        run convert_command,  "#{args.join(' ')} #{quote tempfile.path}"

        [
          tempfile,
          {:format => format, :name => "text.#{format}"}
        ]
      end

    end
  end
end
