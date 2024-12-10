USE DT;
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
        SELECT id, limitage_vn, country_name_vn, type_name_vn, brief_vn, name_vn, director, actor, image, release_date, end_date, duration
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
        INSERT INTO log (message, timestamp)
        VALUES ('Dữ liệu đã được chuyển vào bảng fact_phim thành công!', GETDATE());

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
        INSERT INTO log (message, timestamp)
        VALUES ('Lỗi khi chuyển dữ liệu vào bảng fact_phim: ' + @error_message, GETDATE());
        
        -- Quay lại trạng thái của giao dịch
        ROLLBACK;
    END CATCH;

END;
GO