drop PROCEDURE _SBLanguage;

DELIMITER $$
CREATE PROCEDURE _SBLanguage
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
    
    DECLARE State INT;
    
    -- ---------------------------------------------------------------------------------------------------
    -- Check --
	call _SBLanguage_Check
		(
			 InData_OperateFlag		
			,InData_CompanySeq		
			,InData_LanguageName		
			,InData_ChgLanguageName		
			,InData_Remark			
			,InData_IsUse			
			,Login_UserSeq			
			,@Error_Check
		);
    

	IF( @Error_Check = (SELECT 9999) ) THEN
		
        SET State = 9999; -- Error 발생
        
	ELSE

	    SET State = 1111; -- 정상작동
        
		-- ---------------------------------------------------------------------------------------------------
		-- Save --
		IF( (InData_OperateFlag = 'S' OR InData_OperateFlag = 'D') AND STATE = 1111 ) THEN
			call _SBLanguage_Save
				(
					 InData_OperateFlag		
					,InData_CompanySeq		
					,InData_LanguageName		
					,InData_ChgLanguageName		
					,InData_Remark			
					,InData_IsUse			
					,Login_UserSeq					
				);
		END IF;	
    
		-- ---------------------------------------------------------------------------------------------------
		-- Update --
		IF( InData_OperateFlag = 'U' AND STATE = 1111 ) THEN
			call _SBLanguage_Update
				(
					 InData_OperateFlag		
					,InData_CompanySeq		
					,InData_LanguageName		
					,InData_ChgLanguageName		
					,InData_Remark			
					,InData_IsUse			
					,Login_UserSeq			
				);		
		END IF;	    

	END IF;
END $$
DELIMITER ;