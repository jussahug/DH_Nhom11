CREATE DATABASE abc;
GO
USE abc;
GO
-- Bảng Giới Hạn Độ Tuổi
CREATE TABLE gioiHanDoTuoi (
    id INT IDENTITY(1,1) PRIMARY KEY,
    limitage_vn INT,  -- Ký hiệu (limitage_vn)
    brief_vn NVARCHAR(255)      -- Mô tả (brief_vn)
);
GO
-- Bảng Quốc Gia
CREATE TABLE quocGia (
    id INT IDENTITY(1,1) PRIMARY KEY,
    country_name_vn NVARCHAR(255)  -- Tên quốc gia (country_name_vn)
);
GO
-- Bảng Thể Loại
CREATE TABLE theLoai (
    id INT IDENTITY(1,1) PRIMARY KEY,
    type_name_vn NVARCHAR(255)  -- Tên thể loại (type_name_vn)
);
GO
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
GO
-- Bảng Liên Kết Phim và Thể Loại
CREATE TABLE phim_TheLoai (
    phim_id INT,
    theLoai_id INT,
    PRIMARY KEY (phim_id, theLoai_id)
);
GO
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
GO
-- Bảng Config
CREATE TABLE config (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),  -- Tên cấu hình (name)
    source NVARCHAR(255),  -- Nguồn (source)
    source_fileLocation NVARCHAR(255),  -- Vị trí file nguồn (source_fileLocation)
    des_fileLocation NVARCHAR(255),  -- Vị trí file đích (des_fileLocation)
    created_date DATETIME DEFAULT GETDATE() -- Ngày tạo (created_date)
);
GO
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
GO

CREATE TABLE fact_phim (
    id INT PRIMARY KEY,
    limitage_id INT,
    country_id INT,
    type_id INT,
    brief_id INT,
    name_id INT,
    director_id INT,
    actor_id INT,
    image NVARCHAR(255),
    release_date DATE,
    end_date DATE,
    duration INT
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

-- Thủ tục load_fact_phim_data
CREATE PROCEDURE load_fact_phim_data
AS
BEGIN
    SET NOCOUNT ON;

    -- Khai báo các biến
    DECLARE @id INT, @limitage_id INT, @country_id INT, @type_id INT;
    DECLARE @brief_id INT, @name_id INT, @director_id INT, @actor_id INT;
    DECLARE @image NVARCHAR(255), @release_date DATE, @end_date DATE, @duration INT;
    DECLARE @error_message NVARCHAR(MAX);

    BEGIN TRY
        -- Duyệt từng dòng trong bảng staging và chuyển dữ liệu vào bảng fact
        DECLARE phim_cursor CURSOR FOR
        SELECT id, limitage_vn, country_name_vn, brief_vn, name_vn, director, actor, image, release_date, end_date, duration
        FROM phimChieuRap_Staging;

        OPEN phim_cursor;
        FETCH NEXT FROM phim_cursor INTO @id, @limitage_id, @country_id, @type_id, @brief_id, @name_id, @director_id, @actor_id, @image, @release_date, @end_date, @duration;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Chèn dữ liệu vào bảng fact_phim
            INSERT INTO fact_phim (
                id, limitage_id, country_id, type_id, brief_id, name_id, director_id, actor_id, 
                image, release_date, end_date, duration
            )
            VALUES (
                @id, @limitage_id, @country_id, @type_id, @brief_id, @name_id, @director_id, @actor_id, 
                @image, @release_date, @end_date, @duration
            );

            -- Lấy phần tử tiếp theo
            FETCH NEXT FROM phim_cursor INTO @id, @limitage_id, @country_id, @type_id, @brief_id, @name_id, @director_id, @actor_id, @image, @release_date, @end_date, @duration;
        END;

        CLOSE phim_cursor;
        DEALLOCATE phim_cursor;

        -- Ghi log vào bảng log nếu load thành công
        -- INSERT INTO log (message, timestamp)
        -- VALUES ('Dữ liệu đã được chuyển vào bảng fact_phim thành công!', GETDATE());

        -- Hiển thị nội dung các bảng dim liên quan
        SELECT
            f.id,
            l.kiHieu AS limitage,
            q.tenQuocGia AS country,
            t.theLoai AS type,
            b.brief_vn AS brief,
            n.name_vn AS name,
            d.director AS director,
            a.actor AS actor,
            f.image,
            f.release_date,
            f.end_date,
            f.duration
        FROM fact_phim f
        JOIN dim_gioiHanDoTuoi l ON f.limitage_id = l.gioiHanDoTuoi_id
        JOIN dim_quocGia q ON f.country_id = q.quocGia_id
        JOIN dim_theLoai t ON f.type_id = t.theLoai_id
        JOIN dim_brief_vn b ON f.brief_id = b.brief_vn_id
        JOIN dim_name_vn n ON f.name_id = n.name_vn_id
        JOIN dim_director d ON f.director_id = d.director_id
        JOIN dim_actor a ON f.actor_id = a.actor_id;

    END TRY
    BEGIN CATCH
        -- Lưu thông báo lỗi vào biến @error_message
        SET @error_message = ERROR_MESSAGE();

        -- Ghi log vào bảng log nếu có lỗi
        --INSERT INTO log (message, timestamp)
        --VALUES ('Lỗi khi chuyển dữ liệu vào bảng fact_phim: ' + @error_message, GETDATE());
        
        -- Quay lại trạng thái của giao dịch
        ROLLBACK;
    END CATCH;

END;
GO
-- Thủ tục transform_phim_data
CREATE PROCEDURE transform_phim_data
AS
BEGIN
    SET NOCOUNT ON;

    -- Khai báo các biến
    DECLARE @id INT, @limitage NVARCHAR(255), @country NVARCHAR(255), @type NVARCHAR(255);
    DECLARE @brief NVARCHAR(MAX), @name NVARCHAR(255), @director NVARCHAR(255), @actor NVARCHAR(255);
    DECLARE @image NVARCHAR(255), @release_date DATE, @end_date DATE, @duration INT;
    DECLARE @limitage_id INT, @country_id INT, @type_id INT, @brief_id INT, @name_id INT, @director_id INT, @actor_id INT;

    -- Duyệt từng dòng trong bảng staging và chuyển đổi dữ liệu
    DECLARE phim_cursor CURSOR FOR
    SELECT id, limitage_vn, country_name_vn, brief_vn, name_vn, director, actor, image, release_date, end_date, duration
    FROM phimChieuRap_Staging;

    OPEN phim_cursor;
    FETCH NEXT FROM phim_cursor INTO @id, @limitage, @country, @type, @brief, @name, @director, @actor, @image, @release_date, @end_date, @duration;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Transform các giá trị 'unknown' thành -1
        IF @limitage = 'unknown' SET @limitage = '-1';
        IF @country = 'unknown' SET @country = '-1';
        IF @type = 'unknown' SET @type = '-1';
        IF @brief = 'unknown' SET @brief = '-1';
        IF @name = 'unknown' SET @name = '-1';
        IF @director = 'unknown' SET @director = '-1';
        IF @actor = 'unknown' SET @actor = '-1';

        -- Transform các cột limitage_vn
        SELECT @limitage_id = gioiHanDoTuoi_id
        FROM dim_gioiHanDoTuoi
        WHERE kiHieu = @limitage;

        IF @limitage_id IS NULL
        BEGIN
            INSERT INTO dim_gioiHanDoTuoi (kiHieu)
            VALUES (@limitage);
            SET @limitage_id = SCOPE_IDENTITY();
        END;

        UPDATE phimChieuRap_Staging
        SET limitage_vn = CAST(@limitage_id AS NVARCHAR(255))
        WHERE id = @id;

        -- Transform các cột country_name_vn
        SELECT @country_id = quocGia_id
        FROM dim_quocGia
        WHERE tenQuocGia = @country;

        IF @country_id IS NULL
        BEGIN
            INSERT INTO dim_quocGia (tenQuocGia)
            VALUES (@country);
            SET @country_id = SCOPE_IDENTITY();
        END;

        UPDATE phimChieuRap_Staging
        SET country_name_vn = CAST(@country_id AS NVARCHAR(255))
        WHERE id = @id;

        -- Transform các cột type_name_vn
        SELECT @type_id = theLoai_id
        FROM dim_theLoai
        WHERE theLoai = @type;

        IF @type_id IS NULL
        BEGIN
            INSERT INTO dim_theLoai (theLoai)
            VALUES (@type);
            SET @type_id = SCOPE_IDENTITY();
        END;

        --UPDATE phimChieuRap_Staging
        --SET type_name_vn = CAST(@type_id AS NVARCHAR(255))
        --WHERE id = @id;

        -- Transform các cột brief_vn
        SELECT @brief_id = brief_vn_id
        FROM dim_brief_vn
        WHERE brief_vn = @brief;

        IF @brief_id IS NULL
        BEGIN
            INSERT INTO dim_brief_vn (brief_vn)
            VALUES (@brief);
            SET @brief_id = SCOPE_IDENTITY();
        END;

        UPDATE phimChieuRap_Staging
        SET brief_vn = CAST(@brief_id AS NVARCHAR(255))
        WHERE id = @id;

        -- Transform các cột name_vn
        SELECT @name_id = name_vn_id
        FROM dim_name_vn
        WHERE name_vn = @name;

        IF @name_id IS NULL
        BEGIN
            INSERT INTO dim_name_vn (name_vn)
            VALUES (@name);
            SET @name_id = SCOPE_IDENTITY();
        END;

        UPDATE phimChieuRap_Staging
        SET name_vn = CAST(@name_id AS NVARCHAR(255))
        WHERE id = @id;

        -- Transform các cột director
        SELECT @director_id = director_id
        FROM dim_director
        WHERE director = @director;

        IF @director_id IS NULL
        BEGIN
            INSERT INTO dim_director (director)
            VALUES (@director);
            SET @director_id = SCOPE_IDENTITY();
        END;

        UPDATE phimChieuRap_Staging
        SET director = CAST(@director_id AS NVARCHAR(255))
        WHERE id = @id;

        -- Transform các cột actor
        SELECT @actor_id = actor_id
        FROM dim_actor
        WHERE actor = @actor;

        IF @actor_id IS NULL
        BEGIN
            INSERT INTO dim_actor (actor)
            VALUES (@actor);
            SET @actor_id = SCOPE_IDENTITY();
        END;

        UPDATE phimChieuRap_Staging
        SET actor = CAST(@actor_id AS NVARCHAR(255))
        WHERE id = @id;

        -- Giữ nguyên các cột không transform: image, release_date, end_date, duration
        UPDATE phimChieuRap_Staging
        SET 
            image = @image,
            release_date = @release_date,
            end_date = @end_date,
            duration = @duration
        WHERE id = @id;

        -- Lấy phần tử tiếp theo
        FETCH NEXT FROM phim_cursor INTO @id, @limitage, @country, @type, @brief, @name, @director, @actor, @image, @release_date, @end_date, @duration;
    END;

    CLOSE phim_cursor;
    DEALLOCATE phim_cursor;

    -- Ghi log vào bảng log
    -- INSERT INTO log (message, timestamp)
    --VALUES ('Dữ liệu đã được chuyển đổi thành công!', GETDATE());
END;
GO


