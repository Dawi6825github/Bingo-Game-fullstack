#!/bin/bash

# Rename the new files to replace the existing ones
mv src/app/page2.tsx src/app/page.tsx
mv src/app/layout2.tsx src/app/layout.tsx
mv src/app/auth/login/page2.tsx src/app/auth/login/page.tsx
mv src/app/auth/register/page2.tsx src/app/auth/register/page.tsx
mv src/contexts/AuthContextNew.tsx src/contexts/AuthContext.tsx
mv src/app/providers2.tsx src/app/providers.tsx

# Clean up temporary files
rm -f src/components/RegisterTemp.tsx
rm -f src/components/RegisterFinal.tsx
rm -f src/components/Register.tsx
rm -f src/components/Login.tsx
rm -f src/app/auth/register/RegisterPageTemp.tsx
rm -f rename-files.sh
