extends Node2D

var current_open = ""

var exx : Image
var ccp = ""

func _extract_mtx(path : String):
	
	var file = FileAccess.open(path, FileAccess.READ)
	
	var version = file.get_32()
	
	if version == 0:
		
		var length_first = file.get_32()
		var length_second = file.get_32()
		
		var first
		var second
		
		if length_first > 0:
			first = file.get_buffer(length_first)
		
		if length_second > 0:
			second = file.get_buffer(length_second)
		
		var image_first = Image.new()
		image_first.load_jpg_from_buffer(first)
		
		var image_second = Image.new()
		image_second.load_jpg_from_buffer(second)
		
		var texture = ImageTexture.new()
		
		$Preview/PreviewFirst.texture = texture.create_from_image(image_first)
		
		$Preview/PreviewSecond.texture = texture.create_from_image(image_second)
		
		return image_first
		
	elif version == 1:
	
		var _length_first = file.get_32()
		var _length_second = file.get_32()
		
		var _block_magic = file.get_32()
		var width = file.get_32()
		var height = file.get_32()
		
		var color_length = file.get_32()
		var color_data = file.get_buffer(color_length)
		
		var mask_length = file.get_32()
		var mask_data = file.get_buffer(mask_length)
		
		var expected_size = width * height
		
		var mask = mask_data.decompress_dynamic(
			expected_size,
			FileAccess.COMPRESSION_DEFLATE
		)
		
		var image = Image.new()
		var err = image.load_jpg_from_buffer(color_data)
		
		if err != OK:
			return
		
		if image.get_width() != width or image.get_height() != height:
			return
		
		if mask.size() != expected_size:
			return
		
		image.convert(Image.FORMAT_RGBA8)
		
		for y in range(height):
			for x in range(width):
				var index = y * width + x
				
				var color = image.get_pixel(x, y)
				var alpha = float(mask[index]) / 255.0
				
				color.a = alpha
				
				image.set_pixel(x, y, color)
		
		var texture = ImageTexture.new()
		
		$Preview/PreviewFirst.texture = texture.create_from_image(image)
		
		var _block_magic_2 = file.get_32()
		var width_2 = file.get_32()
		var height_2 = file.get_32()
		
		var color_length_2 = file.get_32()
		var color_data_2 = file.get_buffer(color_length_2)
		
		var mask_length_2 = file.get_32()
		var mask_data_2 = file.get_buffer(mask_length_2)
		
		var expected_size_2 = width_2 * height_2
		
		var mask_2 = mask_data_2.decompress_dynamic(
			expected_size_2,
			FileAccess.COMPRESSION_DEFLATE
		)
		
		var image_2 = Image.new()
		var err_2 = image_2.load_jpg_from_buffer(color_data_2)
		
		if err_2 != OK:
			return
		
		if image_2.get_width() != width_2 or image_2.get_height() != height_2:
			return
		
		if mask_2.size() != expected_size_2:
			return
		
		image_2.convert(Image.FORMAT_RGBA8)
		
		for y in range(height_2):
			for x in range(width_2):
				var index_2 = y * width_2 + x
				
				var color_2 = image_2.get_pixel(x, y)
				var alpha_2 = float(mask_2[index_2]) / 255.0
				
				color_2.a = alpha_2
				
				image_2.set_pixel(x, y, color_2)
		
		var texture_2 = ImageTexture.new()
		
		$Preview/PreviewSecond.texture = texture_2.create_from_image(image_2)
		
		return image
		
func _bake_mtx(png_path : String, mtx_path : String):
	
	var image = Image.load_from_file(png_path)
	
	if image == null:
		return
	
	if image.is_empty():
		return
	
	image.convert(Image.FORMAT_RGBA8)
	
	var width = image.get_width()
	var height = image.get_height()
	
	var color_data_1 = image.save_jpg_to_buffer(0.9)
	
	if color_data_1.is_empty():
		return
	
	var mask_raw_1 = PackedByteArray()
	mask_raw_1.resize(width * height)
	
	for y in range(height):
		for x in range(width):
			
			var index = y * width + x
			var color = image.get_pixel(x, y)
			
			mask_raw_1[index] = roundi(color.a * 255.0)
	
	var mask_data_1 = mask_raw_1.compress(FileAccess.COMPRESSION_DEFLATE)
	
	var width_2 = width
	var height_2 = height
	
	var color_data_2 = image.save_jpg_to_buffer(0.9)
	
	if color_data_2.is_empty():
		return
	
	var mask_raw_2 = PackedByteArray()
	mask_raw_2.resize(width_2 * height_2)
	
	for y in range(height_2):
		for x in range(width_2):
			
			var index_2 = y * width_2 + x
			var color_2 = image.get_pixel(x, y)
			
			mask_raw_2[index_2] = roundi(color_2.a * 255.0)
	
	var mask_data_2 = mask_raw_2.compress(FileAccess.COMPRESSION_DEFLATE)
	
	var file = FileAccess.open(mtx_path, FileAccess.WRITE)
	
	if file == null:
		return
	
	file.store_32(1)
	
	var block_size_1 = 12 + 4 + color_data_1.size() + 4 + mask_data_1.size()
	var block_size_2 = 12 + 4 + color_data_2.size() + 4 + mask_data_2.size()
	
	file.store_32(block_size_1)
	file.store_32(block_size_2)
	
	file.store_32(1)
	file.store_32(width)
	file.store_32(height)
	
	file.store_32(color_data_1.size())
	file.store_buffer(color_data_1)
	
	file.store_32(mask_data_1.size())
	file.store_buffer(mask_data_1)
	
	file.store_32(1)
	file.store_32(width_2)
	file.store_32(height_2)
	
	file.store_32(color_data_2.size())
	file.store_buffer(color_data_2)
	
	file.store_32(mask_data_2.size())
	file.store_buffer(mask_data_2)
	
	file.close()

func _on_mtxtopng_button_down() -> void:
	DisplayServer.file_dialog_show(
		"Select mtx",
		OS.get_system_dir(OS.SYSTEM_DIR_PICTURES),
		"",
		false,
		DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
		PackedStringArray(["*.mtx"]),
		Callable(self, "_mtx_convert")
	)

func _mtx_convert(status: bool, selected_paths: PackedStringArray, selected_filter_index: int):
	
	if status == false:
		return
		
	exx = _extract_mtx(selected_paths[0])
	DisplayServer.file_dialog_show(
		"Select path",
		OS.get_system_dir(OS.SYSTEM_DIR_PICTURES),
		"",
		false,
		DisplayServer.FILE_DIALOG_MODE_SAVE_FILE,
		PackedStringArray(["*.png;Image"]),
		Callable(self, "_save_png")
	)

func _save_png(status: bool, selected_paths: PackedStringArray, selected_filter_index: int):
	if status == false:
		return
	
	var file = FileAccess.open(selected_paths[0], FileAccess.WRITE)
	file.store_buffer(exx.save_png_to_buffer())

func _on_pngtomtx_button_down() -> void:
	DisplayServer.file_dialog_show(
		"Select png",
		OS.get_system_dir(OS.SYSTEM_DIR_PICTURES),
		"",
		false,
		DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
		PackedStringArray(["*.png;Image"]),
		Callable(self, "_png_convert")
	)

func _png_convert(status: bool, selected_paths: PackedStringArray, selected_filter_index: int):
	if status == false:
		return
	
	ccp = selected_paths[0]
	DisplayServer.file_dialog_show(
		"Select path",
		OS.get_system_dir(OS.SYSTEM_DIR_PICTURES),
		"",
		false,
		DisplayServer.FILE_DIALOG_MODE_SAVE_FILE,
		PackedStringArray(["*.mtx"]),
		Callable(self, "_save_mtx")
	)

func _save_mtx(status: bool, selected_paths: PackedStringArray, selected_filter_index: int):
	if status == false:
		return
	
	_bake_mtx(ccp, selected_paths[0])
	_extract_mtx(selected_paths[0])
