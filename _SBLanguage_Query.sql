drop PROCEDURE _SBLanguage_Query;

DELIMITER $$
CREATE PROCEDURE _SBLanguage_Query
	(
		 InData_CompanySeq			INT				-- 법인내부코드
		,InData_LanguageName		VARCHAR(50)		-- 언어명
		,Login_UserSeq				INT				-- 현재 로그인 중인 유저
    )
BEGIN    

	IF (InData_LanguageName 	IS NULL OR InData_LanguageName 	LIKE ''	) THEN	SET InData_LanguageName 	= '%'; END IF;

    -- ---------------------------------------------------------------------------------------------------
    -- Query --
 
    set session transaction isolation level read uncommitted; 
    -- 최종조회 --
    SELECT 
		 A.CompanySeq				AS CompanySeq		
		,A.LanguageSeq				AS LanguageSeq	
		,A.LanguageName				AS LanguageName	
		,A.Remark					AS Remark			
		,A.IsUse					AS IsUse			
		,B.UserName					AS LastUserName	
		,B.UserSeq					AS LastUserSeq	
		,A.LastDateTime				AS LastDateTime	
	FROM _TCBaseLanguage 				AS A
	LEFT OUTER JOIN _TCBaseUser			AS B    ON B.CompanySeq			= A.CompanySeq
											   AND B.UserSeq		    = A.LastUserSeq
    WHERE A.CompanySeq    			=    InData_CompanySeq
      AND A.LanguageName 			LIKE InData_LanguageName;

	set session transaction isolation level repeatable read;
    
END $$
DELIMITER ;