-- Bảng Giới Hạn Độ Tuổi
CREATE DATABASE DT;
CREATE TABLE gioiHanDoTuoi (
    id INT IDENTITY(1,1) PRIMARY KEY,
    limitage_vn NVARCHAR(255),  -- Ký hiệu (limitage_vn)
    brief_vn NVARCHAR(255)      -- Mô tả (brief_vn)
);

-- Bảng Quốc Gia
CREATE TABLE quocGia (
    id INT IDENTITY(1,1) PRIMARY KEY,
    country_name_vn NVARCHAR(255)  -- Tên quốc gia (country_name_vn)
);

-- Bảng Thể Loại
CREATE TABLE theLoai (
    id INT IDENTITY(1,1) PRIMARY KEY,
    type_name_vn NVARCHAR(255)  -- Tên thể loại (type_name_vn)
);

-- Bảng Phim Chiếu Rạp
CREATE TABLE phimChieuRap (
    id INT IDENTITY(1,1) PRIMARY KEY,
    time INT,  -- Thời gian (time)
    name_vn NVARCHAR(255),  -- Tên phim (name_vn)
    director NVARCHAR(255),  -- Đạo diễn (director)
    actor NVARCHAR(255),  -- Diễn viên (actor)
    limitage_vn INT,  -- Giới hạn độ tuổi (limitage_vn)
    country_name_vn INT,  -- Quốc gia (country_name_vn)
    brief_vn NVARCHAR(MAX),  -- Mô tả (brief_vn)
    image NVARCHAR(255),  -- URL ảnh (image)
    release_date DATE,  -- Ngày phát hành (release_date)
    end_date DATE,  -- Ngày kết thúc (end_date)
    duration INT,  -- Thời gian (duration)
    created_at DATETIME DEFAULT GETDATE(),  -- Ngày tạo (created_at)
    updated_at DATETIME DEFAULT GETDATE()  -- Ngày cập nhật (updated_at)
);

-- Bảng Liên Kết Phim và Thể Loại
CREATE TABLE phim_TheLoai (
    phim_id INT,
    theLoai_id INT,
    PRIMARY KEY (phim_id, theLoai_id)
);

-- Bảng Log
CREATE TABLE log (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_config INT,  -- ID cấu hình (id_config)
    fileName NVARCHAR(255),  -- Tên file (fileName)
    count INT,  -- Số lượng (count)
    status NVARCHAR(50),  -- Trạng thái (status)
    file_size INT,  -- Kích thước file (file_size)
    date_create DATE,  -- Ngày tạo (date_create)
    date_update DATE  -- Ngày cập nhật (date_update)
);

-- Bảng Config
CREATE TABLE config (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),  -- Tên cấu hình (name)
    source NVARCHAR(255),  -- Nguồn (source)
    source_fileLocation NVARCHAR(255),  -- Vị trí file nguồn (source_fileLocation)
    des_fileLocation NVARCHAR(255),  -- Vị trí file đích (des_fileLocation)
    created_date DATETIME DEFAULT GETDATE() -- Ngày tạo (created_date)
);

-- Bảng Phim Chiếu Rạp Staging
CREATE TABLE phimChieuRap_Staging (
    id INT IDENTITY(1,1) PRIMARY KEY,
    time INT,  -- Thời gian (time)
    name_vn NVARCHAR(255),  -- Tên phim (name_vn)
    director NVARCHAR(255),  -- Đạo diễn (director)
    actor NVARCHAR(255),  -- Diễn viên (actor)
    limitage_vn INT,  -- Giới hạn độ tuổi (limitage_vn)
    country_name_vn INT,  -- Quốc gia (country_name_vn)
    brief_vn NVARCHAR(MAX),  -- Mô tả (brief_vn)
    image NVARCHAR(255),  -- URL ảnh (image)
    release_date DATE,  -- Ngày phát hành (release_date)
    end_date DATE,  -- Ngày kết thúc (end_date)
    duration INT,  -- Thời gian (duration)
    created_at DATETIME DEFAULT GETDATE(),  -- Ngày tạo (created_at)
    updated_at DATETIME DEFAULT GETDATE()  -- Ngày cập nhật (updated_at)
);

-- Kiểm tra và tạo Bảng Giới Hạn Độ Tuổi nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'gioiHanDoTuoi' AND xtype = 'U')
BEGIN
    CREATE TABLE gioiHanDoTuoi (
        id INT IDENTITY(1,1) PRIMARY KEY,
        limitage_vn NVARCHAR(255),  -- Ký hiệu (limitage_vn)
        brief_vn NVARCHAR(255)      -- Mô tả (brief_vn)
    );
END

-- Kiểm tra và tạo Bảng Quốc Gia nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'quocGia' AND xtype = 'U')
BEGIN
    CREATE TABLE quocGia (
        id INT IDENTITY(1,1) PRIMARY KEY,
        country_name_vn NVARCHAR(255)  -- Tên quốc gia (country_name_vn)
    );
END

-- Kiểm tra và tạo Bảng Thể Loại nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'theLoai' AND xtype = 'U')
BEGIN
    CREATE TABLE theLoai (
        id INT IDENTITY(1,1) PRIMARY KEY,
        type_name_vn NVARCHAR(255)  -- Tên thể loại (type_name_vn)
    );
END

-- Kiểm tra và tạo Bảng Phim Chiếu Rạp nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'phimChieuRap' AND xtype = 'U')
BEGIN
    CREATE TABLE phimChieuRap (
        id INT IDENTITY(1,1) PRIMARY KEY,
        time INT,  -- Thời gian (time)
        name_vn NVARCHAR(255),  -- Tên phim (name_vn)
        director NVARCHAR(255),  -- Đạo diễn (director)
        actor NVARCHAR(255),  -- Diễn viên (actor)
        limitage_vn INT,  -- Giới hạn độ tuổi (limitage_vn)
        country_name_vn INT,  -- Quốc gia (country_name_vn)
        brief_vn NVARCHAR(MAX),  -- Mô tả (brief_vn)
        image NVARCHAR(255),  -- URL ảnh (image)
        release_date DATE,  -- Ngày phát hành (release_date)
        end_date DATE,  -- Ngày kết thúc (end_date)
        duration INT,  -- Thời gian (duration)
        created_at DATETIME DEFAULT GETDATE(),  -- Ngày tạo (created_at)
        updated_at DATETIME DEFAULT GETDATE()  -- Ngày cập nhật (updated_at)
    );
END

-- Kiểm tra và tạo Bảng Liên Kết Phim và Thể Loại nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'phim_TheLoai' AND xtype = 'U')
BEGIN
    CREATE TABLE phim_TheLoai (
        phim_id INT,
        theLoai_id INT,
        PRIMARY KEY (phim_id, theLoai_id)
    );
END

-- Kiểm tra và tạo Bảng Log nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'log' AND xtype = 'U')
BEGIN
    CREATE TABLE log (
        id INT IDENTITY(1,1) PRIMARY KEY,
        id_config INT,  -- ID cấu hình (id_config)
        fileName NVARCHAR(255),  -- Tên file (fileName)
        count INT,  -- Số lượng (count)
        status NVARCHAR(50),  -- Trạng thái (status)
        file_size INT,  -- Kích thước file (file_size)
        date_create DATE,  -- Ngày tạo (date_create)
        date_update DATE  -- Ngày cập nhật (date_update)
    );
END

-- Kiểm tra và tạo Bảng Config nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'config' AND xtype = 'U')
BEGIN
    CREATE TABLE config (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(255),  -- Tên cấu hình (name)
        source NVARCHAR(255),  -- Nguồn (source)
        source_fileLocation NVARCHAR(255),  -- Vị trí file nguồn (source_fileLocation)
        des_fileLocation NVARCHAR(255),  -- Vị trí file đích (des_fileLocation)
        created_date DATETIME DEFAULT GETDATE() -- Ngày tạo (created_date)
    );
END

-- Kiểm tra và tạo Bảng Phim Chiếu Rạp Staging nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'phimChieuRap_Staging' AND xtype = 'U')
BEGIN
    CREATE TABLE phimChieuRap_Staging (
        id INT IDENTITY(1,1) PRIMARY KEY,
        time INT,  -- Thời gian (time)
        name_vn NVARCHAR(255),  -- Tên phim (name_vn)
        director NVARCHAR(255),  -- Đạo diễn (director)
        actor NVARCHAR(255),  -- Diễn viên (actor)
        limitage_vn INT,  -- Giới hạn độ tuổi (limitage_vn)
        country_name_vn INT,  -- Quốc gia (country_name_vn)
        brief_vn NVARCHAR(MAX),  -- Mô tả (brief_vn)
        image NVARCHAR(255),  -- URL ảnh (image)
        release_date DATE,  -- Ngày phát hành (release_date)
        end_date DATE,  -- Ngày kết thúc (end_date)
        duration INT,  -- Thời gian (duration)
        created_at DATETIME DEFAULT GETDATE(),  -- Ngày tạo (created_at)
        updated_at DATETIME DEFAULT GETDATE()  -- Ngày cập nhật (updated_at)
    );
END

-- Kiểm tra và tạo Thủ Tục insert_or_update_phimchieurapStaging nếu chưa tồn tại
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'insert_or_update_phimchieurapStaging' AND xtype = 'P')
BEGIN
    DROP PROCEDURE insert_or_update_phimchieurapStaging;
END
GO

CREATE PROCEDURE insert_or_update_phimchieurapStaging
(
    @p_name_vn NVARCHAR(255),
    @p_director NVARCHAR(255),
    @p_actor NVARCHAR(255),
    @p_limitage_vn NVARCHAR(255),
    @p_country_name_vn NVARCHAR(255),
    @p_brief_vn NVARCHAR(MAX),
    @p_image NVARCHAR(255),
    @p_release_date DATE,
    @p_end_date DATE,
    @p_duration INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @existing_id INT;
    DECLARE @limitage_vn NVARCHAR(255);  -- Giữ limitage_vn là NVARCHAR
    DECLARE @country_name_vn INT;

    -- Không chuyển đổi limitage_vn thành INT, để nó là chuỗi
    SET @limitage_vn = @p_limitage_vn;  -- Gán giá trị trực tiếp vào

    -- Kiểm tra và chuyển đổi country_name_vn nếu cần
    IF ISNUMERIC(@p_country_name_vn) = 1
    BEGIN
        SET @country_name_vn = CAST(@p_country_name_vn AS INT);
    END
    ELSE
    BEGIN
        SET @country_name_vn = NULL;  -- Hoặc giá trị mặc định nếu cần
    END

    -- Kiểm tra xem có bản ghi nào với name_vn và time đã tồn tại hay không
    SELECT @existing_id = id
    FROM phimChieuRap_Staging
    WHERE name_vn = @p_name_vn AND time = @p_duration;

    -- Nếu không có bản ghi tồn tại, thêm mới và thiết lập created_at và updated_at
    IF @existing_id IS NULL
    BEGIN
        INSERT INTO phimChieuRap_Staging (
            name_vn, director, actor, limitage_vn, country_name_vn,
            brief_vn, image, release_date, end_date, time, created_at, updated_at
        )
        VALUES (
            @p_name_vn, @p_director, @p_actor, @limitage_vn, @country_name_vn,
            @p_brief_vn, @p_image, @p_release_date, @p_end_date, @p_duration, GETDATE(), GETDATE()
        );
    END
    ELSE
    BEGIN
        -- Nếu đã tồn tại, cập nhật trường updated_at
        UPDATE phimChieuRap_Staging
        SET updated_at = GETDATE()
        WHERE id = @existing_id;
    END
END;
GO
