#!/bin/bash

echo "-----ndnSIM自動化インストールスクリプト-----"
echo "作成者：カラス海岸"
echo "バージョン：2.0"

#初期化
mkdir ndnSIM
cd ndnSIM
aPath1=`pwd`                             #ndnSIMフォルダー絶対パス
aPath2=$aPath1"/ns-3"              #ns-3フォルダー絶対パス
aPath3=$aPath1"/pybindgen"    #pybindgenフォルダー絶対パス
aPath4=$aPath1"ns-3/src/ndnSIM"
file1="https://raw.githubusercontent.com/Karasukaigan/ndnsim-automatic-installation/master/base.py"
file2="https://raw.githubusercontent.com/Karasukaigan/ndnsim-automatic-installation/master/hud.py"

#必要なファイルをダウンロード
wget $file1
wget $file2
sudo chmod 777 base.py
sudo chmod 777 hud.py

#ソフトウェアを更新
echo "ソフトウェア更新中..."
sudo apt-get update
sudo apt-get upgrade
echo "ソフトウェア更新完了！"

#依存関係をインストール
echo "依存関係インストール中..."
sudo apt install -y vim
sudo apt install -y build-essential libsqlite3-dev libboost-all-dev libssl-dev git python-setuptools castxml
sudo apt install -y python-dev python-pygraphviz python-kiwi python-gnome2 ipython libcairo2-dev python3-gi libgirepository1.0-dev python-gi python-gi-cairo gir1.2-gtk-3.0 gir1.2-goocanvas-2.0 python-pip
pip install pygraphviz pycairo PyGObject pygccxml
sudo apt-get install -y graphviz libgraphviz-dev graphviz-dev pkg-config
pip install pygraphviz
echo "依存関係インストール完了！"

#ndnSIM本体をダウンロード
echo "ndnSIM本体ダウンロード中..."
git clone https://github.com/named-data-ndnSIM/ns-3-dev.git ns-3
git clone https://github.com/named-data-ndnSIM/pybindgen.git pybindgen
git clone https://github.com/named-data-ndnSIM/ndnSIM.git ns-3/src/ndnSIM
echo "ndnSIM本体ダウンロード完了！"

#バージョンを変更
echo "バージョン変更中..."
cd $aPath4
git checkout ndnSIM-2.7
git submodule update --init
cd $aPath2
git checkout ndnSIM-ns-3.29
cd $aPath3
git checkout 0.19.0
pip install setuptools-scm
sudo python setup.py install
echo "バージョン変更完了！"

#ndnSIMをコンパイル
echo "ndnSIMコンパイル中..."
cd $aPath2
./waf configure --enable-examples
./waf
cd $aPath1
sudo \cp -rf base.py ns-3/src/visualizer/visualizer/base.py
sudo rm -rf base.py
cd $aPath2
./waf
cd $aPath1
sudo \cp -rf hud.py ns-3/src/visualizer/visualizer/hud.py
sudo rm -rf hud.py
echo "ndnSIMコンパイル完了！"
sudo chmod -R 777 ns-3
sudo chmod -R 777 pybindgen
cd $aPath2
echo "ndnSIMを今使用可能になりました。「./waf --run ndn-simple --vis」で確認してみましょう！"
echo "ndnSimInstall.shを削除してください。"
echo "-----スクリプト終了-----"
