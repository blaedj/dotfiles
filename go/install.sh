export GOPATH=$HOME/code/go

go get -u -v golang.org/x/tools/cmd/guru
go get -u -v golang.org/x/tools/cmd/goimports
go get -u -v golang.org/x/tools/cmd/gorename
go get -u -v github.com/rogpeppe/godef
# go get -u github.com/mdempsky/gocode # temporarily use the fork below 
go get -u github.com/ikgo/gocode       # until go module support is merged
go get -u -v github.com/golang/protobuf/protoc-gen-go
# go get golang.org/x/tools/gopls@latest # for when _not_ in GOPATH mode..
go get golang.org/x/tools/gopls
