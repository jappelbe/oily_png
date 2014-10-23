# just a quick benchmark-script of rotation methods.

require 'timeout'
require 'oily_png'

IMAGES_DIR = 'images'
RESULTS_PATH = 'result_images'
TEST_IMAGES = Dir.new(IMAGES_DIR).select {|f| f =~ /.png$/ }.sort
TIMEOUT_SECONDS = 500

TEST_IMAGES.each do |img_file|
  img_path = File.join(IMAGES_DIR, img_file)
  t = Time.now
  img_obj = ChunkyPNG::Image.from_file(img_path)
  resolution = "#{img_obj.width}x#{img_obj.height}"
  result_time = nil
  begin
    Timeout::timeout(TIMEOUT_SECONDS) do
      t = Time.now
      img_obj.rotate_right!
      result_time = Time.now - t
    end
    img_obj.save(File.join(RESULTS_PATH, img_file))
  rescue TimeoutError
    result_time = "timeout after #{TIMEOUT_SECONDS}s"
  end
  puts "#{img_file} (#{resolution}): #{result_time.respond_to?(:round) ? result_time.round(3) : result_time}s"
end

=begin
Results:

Using ChunkyPNG
01.png (727x233): 0.196s
02.png (800x600): 0.496s
03.png (414x500): 0.093s
04.png (1024x819): 0.891s
05.png (1920x1080): 3.928s
06.png (900x720): 0.496s
07.png (1024x819): 0.827s
08.png (1280x798): 1.167s
09.png (5888x4238): 132.099s
10.png (6300x3000): 97.869s
11.png (9725x4862): timeout after 500s

Using OilyPNG
01.png (727x233): 0.003s
02.png (800x600): 0.009s
03.png (414x500): 0.004s
04.png (1024x819): 0.017s
05.png (1920x1080): 0.04s
06.png (900x720): 0.014s
07.png (1024x819): 0.016s
08.png (1280x798): 0.02s
09.png (5888x4238): 1.033s
10.png (6300x3000): 0.434s
11.png (9725x4862): 1.276s

=end