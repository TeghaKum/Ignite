#!/bin/bash

# Ignite Monitoring App - Free Hosting Deployment Script
# This script helps deploy to Vercel (frontend) and Railway (backend)

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Ignite Monitoring App - Free Hosting Deployment${NC}"
echo -e "${BLUE}This script will help you deploy to Vercel (frontend) and Railway (backend)${NC}"

# Check if required tools are installed
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}❌ $1 is not installed. Please install it first.${NC}"
        return 1
    else
        echo -e "${GREEN}✅ $1 is installed${NC}"
        return 0
    fi
}

echo -e "\n${YELLOW}🔍 Checking required tools...${NC}"
TOOLS_OK=true

if ! check_tool "node"; then
    echo -e "${YELLOW}   Install Node.js from: https://nodejs.org/${NC}"
    TOOLS_OK=false
fi

if ! check_tool "npm"; then
    echo -e "${YELLOW}   npm should come with Node.js${NC}"
    TOOLS_OK=false
fi

if ! check_tool "git"; then
    echo -e "${YELLOW}   Install Git from: https://git-scm.com/${NC}"
    TOOLS_OK=false
fi

if [ "$TOOLS_OK" = false ]; then
    echo -e "${RED}❌ Please install the required tools and run this script again.${NC}"
    exit 1
fi

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Vercel CLI...${NC}"
    npm install -g vercel
fi

echo -e "\n${GREEN}🎯 Deployment Options:${NC}"
echo -e "1. Deploy Frontend to Vercel"
echo -e "2. Deploy Backend to Railway"
echo -e "3. Deploy Both (Recommended)"
echo -e "4. Setup Local Development Environment"

read -p "Choose an option (1-4): " choice

case $choice in
    1|3)
        echo -e "\n${GREEN}🌐 Deploying Frontend to Vercel...${NC}"
        
        if [ -d "frontend" ]; then
            cd frontend
            
            # Install dependencies
            echo -e "${YELLOW}📦 Installing dependencies...${NC}"
            npm install
            
            # Build the project
            echo -e "${YELLOW}🔨 Building project...${NC}"
            npm run build
            
            # Deploy to Vercel
            echo -e "${YELLOW}🚀 Deploying to Vercel...${NC}"
            echo -e "${BLUE}💡 You'll need to login to Vercel and follow the prompts${NC}"
            vercel --prod
            
            cd ..
            echo -e "${GREEN}✅ Frontend deployment completed!${NC}"
        else
            echo -e "${RED}❌ Frontend directory not found${NC}"
        fi
        
        if [ "$choice" = "1" ]; then
            break
        fi
        ;&
    2|3)
        echo -e "\n${GREEN}🔨 Preparing Backend for Railway...${NC}"
        
        if [ -d "backend" ]; then
            cd backend
            
            # Create Procfile for Railway
            if [ ! -f "Procfile" ]; then
                echo -e "${YELLOW}📝 Creating Procfile...${NC}"
                echo "web: python src/main.py" > Procfile
            fi
            
            # Create runtime.txt
            if [ ! -f "runtime.txt" ]; then
                echo -e "${YELLOW}📝 Creating runtime.txt...${NC}"
                echo "python-3.11.0" > runtime.txt
            fi
            
            # Ensure requirements.txt exists
            if [ ! -f "requirements.txt" ]; then
                echo -e "${YELLOW}📝 Creating requirements.txt...${NC}"
                cat > requirements.txt << 'EOF'
Flask==2.3.3
Flask-SQLAlchemy==3.0.5
Flask-CORS==4.0.0
python-dotenv==1.0.0
EOF
            fi
            
            cd ..
            
            echo -e "${GREEN}✅ Backend prepared for Railway!${NC}"
            echo -e "\n${BLUE}📋 Next steps for Railway deployment:${NC}"
            echo -e "1. Go to https://railway.app"
            echo -e "2. Sign up/login with GitHub"
            echo -e "3. Create new project from GitHub repo"
            echo -e "4. Select your backend repository"
            echo -e "5. Railway will automatically deploy your app"
            echo -e "6. Get your app URL from Railway dashboard"
        else
            echo -e "${RED}❌ Backend directory not found${NC}"
        fi
        ;;
    4)
        echo -e "\n${GREEN}🏠 Setting up Local Development Environment...${NC}"
        
        # Check if Docker is installed
        if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
            echo -e "${GREEN}✅ Docker and Docker Compose found${NC}"
            echo -e "${YELLOW}🐳 Starting services with Docker Compose...${NC}"
            docker-compose up -d
            echo -e "${GREEN}✅ Services started!${NC}"
            echo -e "${BLUE}📋 Access your app at:${NC}"
            echo -e "   Frontend: http://localhost:3000"
            echo -e "   Backend:  http://localhost:5000"
            echo -e "   Database: localhost:5432"
        else
            echo -e "${YELLOW}⚠️  Docker not found. Setting up manual development environment...${NC}"
            
            # Setup frontend
            if [ -d "frontend" ]; then
                echo -e "${YELLOW}📦 Setting up frontend...${NC}"
                cd frontend
                npm install
                echo -e "${GREEN}✅ Frontend dependencies installed${NC}"
                echo -e "${BLUE}💡 Run 'npm run dev' to start frontend development server${NC}"
                cd ..
            fi
            
            # Setup backend
            if [ -d "backend" ]; then
                echo -e "${YELLOW}🐍 Setting up backend...${NC}"
                cd backend
                
                # Create virtual environment
                python3 -m venv venv
                source venv/bin/activate
                
                # Install dependencies
                pip install -r requirements.txt
                
                echo -e "${GREEN}✅ Backend dependencies installed${NC}"
                echo -e "${BLUE}💡 Run 'source venv/bin/activate && python src/main.py' to start backend${NC}"
                cd ..
            fi
        fi
        ;;
    *)
        echo -e "${RED}❌ Invalid option${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}🎉 Deployment script completed!${NC}"
echo -e "\n${YELLOW}📚 Additional Resources:${NC}"
echo -e "• Vercel Documentation: https://vercel.com/docs"
echo -e "• Railway Documentation: https://docs.railway.app"
echo -e "• Ignite App Repository: [Your GitHub Repository URL]"

echo -e "\n${BLUE}💡 Pro Tips:${NC}"
echo -e "• Set up environment variables in your hosting platforms"
echo -e "• Configure custom domains for professional URLs"
echo -e "• Enable monitoring and analytics"
echo -e "• Set up automated deployments from Git"

