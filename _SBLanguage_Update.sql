drop PROCEDURE _SBLanguage_Update;

DELIMITER $$
CREATE PROCEDURE _SBLanguage_Update
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
    DECLARE Var_GetDateNow			VARCHAR(100);    
    DECLARE Var_LanguageSeq			INT;
    
	SET Var_GetDateNow  = (SELECT DATE_FORMAT(NOW(), "%Y-%m-%d %H:%i:%s") AS GetDate); -- 작업일시는 Update 되는 시점의 일시를 Insert
	SET Var_LanguageSeq = (SELECT A.LanguageSeq FROM _TCBaseLanguage AS A WHERE A.CompanySeq = InData_CompanySeq AND A.LanguageName = InData_LanguageName);   
    
    -- ---------------------------------------------------------------------------------------------------
    -- Update --
	IF( InData_OperateFlag = 'U' ) THEN     
			UPDATE _TCBaseLanguage			AS A
			   SET   A.LanguageName			= InData_ChgLanguageName
			 	    ,A.Remark				= InData_Remark
			 	    ,A.IsUse				= InData_IsUse
				    ,A.LastUserSeq			= Login_UserSeq
				    ,A.LastDateTime			= Var_GetDateNow          
			 WHERE   A.CompanySeq 			= InData_CompanySeq
               AND   A.LanguageSeq			= Var_LanguageSeq;
                     
              SELECT '저장되었습니다.' AS Result; 
                     
	ELSE
			  SELECT '저장이 완료되지 않았습니다.' AS Result;
	END IF;	


END $$
DELIMITER ;