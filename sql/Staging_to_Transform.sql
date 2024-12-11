USE DT;
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
    SELECT id, limitage_vn, country_name_vn, type_name_vn, brief_vn, name_vn, director, actor, image, release_date, end_date, duration
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

        UPDATE phimChieuRap_Staging
        SET type_name_vn = CAST(@type_id AS NVARCHAR(255))
        WHERE id = @id;

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
    INSERT INTO log (message, timestamp)
    VALUES ('Dữ liệu đã được chuyển đổi thành công!', GETDATE());
END;
GO
