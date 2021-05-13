drop PROCEDURE _SBLanguage_Save;

DELIMITER $$
CREATE PROCEDURE _SBLanguage_Save
	(
		 InData_OperateFlag			CHAR(2)			-- 작업표시
		,InData_CompanySeq			INT				-- 법인내부코드
		,InData_LanguageName		VARCHAR(50)		-- (기존)언어명
		,InData_ChgLanguageName		VARCHAR(50)		-- (변경)언어명
		,InData_Remark				VARCHAR(200)	-- 비고
		,InData_IsUse				CHAR(1)			-- 사용여부
		,Login_UserSeq				INT				-- 현재 로그인 중인 유저
    )
BEGIN

	-- 변수선언
    DECLARE Var_LanguageSeq			INT;
    DECLARE Var_GetDateNow			VARCHAR(100);

	SET Var_GetDateNow  		= (SELECT DATE_FORMAT(NOW(), "%Y-%m-%d %H:%i:%s") AS GetDate); -- 작업일시는 Save되는 시점의 일시를 Insert

    -- ---------------------------------------------------------------------------------------------------
    -- Insert --
	IF( InData_OperateFlag = 'S' ) THEN
		INSERT INTO _TCBaseLanguage 
		( 	 
			 CompanySeq			-- 법인내부코드
			,LanguageName		-- 언어명
			,Remark				-- 비고
			,IsUse				-- 사용여부
			,LastUserSeq		-- 작업자
			,LastDateTime   	-- 작업일시
        )
		VALUES
		(
			 InData_CompanySeq			
			,InData_LanguageName		
			,InData_Remark			
			,InData_IsUse	
			,Login_UserSeq	
			,Var_GetDateNow		
		);
        
        SELECT '저장이 완료되었습니다' AS Result;

	-- ---------------------------------------------------------------------------------------------------        
    -- Delete --
	ELSEIF ( InData_OperateFlag = 'D' ) THEN  
    
		SET Var_LanguageSeq = (SELECT A.LanguageSeq FROM _TCBaseLanguage AS A WHERE A.CompanySeq = InData_CompanySeq AND A.LanguageName = InData_LanguageName);  
        
		DELETE FROM _TCBaseLanguage WHERE A.CompanySeq = InData_CompanySeq AND A.LanguageName = InData_LanguageName;

        SELECT '삭제되었습니다.' AS Result; 
        
	END IF;	
    
END $$
DELIMITER ;